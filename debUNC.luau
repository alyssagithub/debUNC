--!strict
type Function = (...any) -> ...any?

const EncodingService = game:GetService("EncodingService")
const UserInputService = game:GetService("UserInputService")
const Player = game:GetService("Players").LocalPlayer

const function GetPlayerScripts(): Instance
	return Player:FindFirstChild("PlayerScripts") or game:GetService("StarterPlayer").StarterPlayerScripts
end

const function GetPlayerModule(): any
	const PlayerModule = GetPlayerScripts():FindFirstChild("PlayerModule") or game:GetService("StarterPlayer"):FindFirstChild("PlayerModule", true)

	if not PlayerModule then
		error({Skipped = "this game has no PlayerModule", Environment = true})
	end

	return PlayerModule
end

const function FindFirstFunction(Name: string, Environment: {[string]: any}?): any
	local Value = Environment or getfenv()

	while Value ~= nil and Name ~= "" do
		local Library, NewName = string.match(Name, "^([^.]+)%.?(.*)$")

		const Success, Found = pcall(function()
			return Value[Library or ""]
		end)

		Value = if Success then Found else nil
		Name = NewName or ""
	end

	return Value
end

const TestThreads: {[thread]: string} = {}
const Cleanups: {[thread]: {() -> ()}} = {}

const function AddCleanup(Cleanup: () -> ())
	const Thread = coroutine.running()

	Cleanups[Thread] = Cleanups[Thread] or {}
	table.insert(Cleanups[Thread], Cleanup)
end

const function RunCleanups(Thread: thread)
	for _, Cleanup in Cleanups[Thread] or {} do
		pcall(Cleanup)
	end

	Cleanups[Thread] = nil
end

const Dependencies: {[string]: {[string]: boolean}} = {}

const Formatters = {
	CheckReturnType = function(Result: any, Type: string)
		assert(typeof(Result) == Type, `didn't return a {Type}`)
	end,

	CheckEqual = function(Result: any, Expected: any, Name: string)
		assert(Result == Expected, `expected {Name} to be {Expected}, got {Result}`)
	end,

	CheckExist = function(FunctionName: string): any
		const TestName = TestThreads[coroutine.running()]
		const FoundFunction = FindFirstFunction(FunctionName)

		if TestName then
			Dependencies[TestName] = Dependencies[TestName] or {}
			Dependencies[TestName][FunctionName] = true
		end

		assert(FoundFunction, `'{FunctionName}' does not exist, and is required for this test`)
		return FoundFunction
	end,
}

const function RemovePath(FunctionName: string, Path: string)
	const Remove = getfenv()[FunctionName]

	if not Remove then
		return
	end

	pcall(Remove, Path)
end

const function WaitFor(Check: () -> boolean, Timeout: number): boolean
	const StartTime = tick()

	repeat
		task.wait()
	until Check() or tick() - StartTime >= Timeout

	return Check()
end

const function CreateRandomString(Length: number): string
	const Characters = table.create(Length)

	for Index = 1, Length do
		Characters[Index] = string.char(math.random(0, 255))
	end

	return table.concat(Characters)
end

local FocusLost = false
local HasFocus = true
local MissedFocusLoss = false
local MessageBoxTime = 0

const FocusConnection = UserInputService.WindowFocusReleased:Connect(function()
	FocusLost = true
	HasFocus = false

	const IsRobloxActive = isrbxactive

	if not IsRobloxActive then
		return
	end

	if not WaitFor(function()
		return HasFocus or not IsRobloxActive()
	end, 1) then
		MissedFocusLoss = true
	end
end)

const FocusGainedConnection = UserInputService.WindowFocused:Connect(function()
	HasFocus = true
end)

const InputTests: {[string]: boolean} = {}

const function IsRobloxFocused(): boolean
	const IsRobloxActive = isrbxactive

	if IsRobloxActive then
		const Success, Active = pcall(IsRobloxActive)

		if Success then
			return Active == true
		end
	end

	return HasFocus
end

const function CheckInputFree()
	const TestName = TestThreads[coroutine.running()]

	if TestName then
		InputTests[TestName] = true
	end

	const IdentifyExecutor = identifyexecutor

	if IdentifyExecutor and tostring((IdentifyExecutor())):lower() == "athena" and not IsRobloxFocused() then
		error({Skipped = "the Roblox window isn't focused, and Athena sends input to whatever window is focused", Environment = FocusLost})
	end

	if not WaitFor(function()
		return UserInputService.MouseBehavior == Enum.MouseBehavior.Default
			and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
	end, 1) then
		error({Skipped = "a mouse button is being held or the mouse is locked", Environment = true})
	end

	local LastInput = os.clock()

	const function OnInput()
		LastInput = os.clock()
	end

	const Connections = {
		UserInputService.InputBegan:Connect(OnInput),
		UserInputService.InputChanged:Connect(OnInput),
		UserInputService.InputEnded:Connect(OnInput),
	}

	const Quiet = WaitFor(function()
		return os.clock() - LastInput >= 0.25
	end, 3)

	for _, Connection in Connections do
		Connection:Disconnect()
	end

	if not Quiet then
		error({Skipped = "the mouse or keyboard was being used during the test", Environment = true})
	end
end

const function WaitForInput(Signal: RBXScriptSignal, Check: (InputObject) -> boolean, Action: () -> ()): boolean
	local Detected = false

	const Connection = Signal:Connect(function(Input)
		if typeof(Input) ~= "Instance" or not Input:IsA("InputObject") or not Check(Input) then
			return
		end

		Detected = true
	end)

	AddCleanup(function()
		Connection:Disconnect()
	end)

	Action()

	const Result = WaitFor(function()
		return Detected
	end, 1)

	Connection:Disconnect()

	return Result
end

const function CenterMouse()
	const MouseMoveAbsolute = mousemoveabs

	if not MouseMoveAbsolute then
		return
	end

	const Center = workspace.CurrentCamera.ViewportSize / 2

	MouseMoveAbsolute(Center.X, Center.Y)
	task.wait()
end

const function CheckPressAndRelease(PressName: string, ReleaseName: string, TestedName: string, IsHeld: () -> boolean, IsInput: (InputObject) -> boolean, Argument: any?)
	const Release = if TestedName == PressName or TestedName == ReleaseName then Formatters.CheckExist(ReleaseName) else getfenv()[ReleaseName]

	local Detected

	if Release then
		AddCleanup(function()
			if IsHeld() then
				Release(Argument)
			end
		end)
	end

	if TestedName == ReleaseName then
		Formatters.CheckExist(PressName)(Argument)

		if not WaitFor(IsHeld, 1) then
			Release(Argument)
			error("the input was never held down, so it can't be released")
		end

		Detected = WaitForInput(UserInputService.InputEnded, IsInput, function()
			Release(Argument)
		end)
	else
		Detected = WaitForInput(UserInputService.InputBegan, IsInput, function()
			getfenv()[TestedName](Argument)
		end)

		if TestedName == PressName then
			Release(Argument)
		end
	end

	const Released = WaitFor(function()
		return not IsHeld()
	end, 1)

	if not Released and Release then
		Release(Argument)
	end

	assert(Detected, "the input wasn't detected")
	assert(Released, "the input was left held down")
end

const function CheckMouseButton(Button: number, TestedName: string)
	const InputType = if Button == 1 then Enum.UserInputType.MouseButton1 else Enum.UserInputType.MouseButton2

	local TouchHeld = false

	if Button == 1 then
		const Connections = {
			UserInputService.InputBegan:Connect(function(Input)
				TouchHeld = TouchHeld or Input.UserInputType == Enum.UserInputType.Touch
			end),
			UserInputService.InputEnded:Connect(function(Input)
				TouchHeld = TouchHeld and Input.UserInputType ~= Enum.UserInputType.Touch
			end),
		}

		AddCleanup(function()
			for _, Connection in Connections do
				Connection:Disconnect()
			end
		end)
	end

	CheckInputFree()
	CenterMouse()

	CheckPressAndRelease(`mouse{Button}press`, `mouse{Button}release`, TestedName, function()
		return UserInputService:IsMouseButtonPressed(InputType) or TouchHeld
	end, function(Input)
		return Input.UserInputType == InputType or (Button == 1 and Input.UserInputType == Enum.UserInputType.Touch)
	end)
end

const function CheckKey(TestedName: string)
	CheckInputFree()

	CheckPressAndRelease("keypress", "keyrelease", TestedName, function()
		return UserInputService:IsKeyDown(Enum.KeyCode.J)
	end, function(Input)
		return Input.KeyCode == Enum.KeyCode.J
	end, 0x4A)
end

const function CheckPacketHook(Direction: string, CheckRemove: boolean)
	const RakNet = raknet

	local Count = 0
	local PacketId
	local MatchedData

	const function OnPacket(Packet)
		Count += 1
		PacketId = PacketId or Packet.PacketId

		if MatchedData ~= nil then
			return
		end

		MatchedData = Packet.Size == #Packet.AsString and buffer.tostring(Packet.AsBuffer) == Packet.AsString
	end

	RakNet[`add{Direction}hook`](OnPacket)

	const Fired = WaitFor(function()
		return Count > 0
	end, 3)

	RakNet[`remove{Direction}hook`](OnPacket)

	const CountAtRemoval = Count

	if CheckRemove and not Fired then
		error({Skipped = `the {Direction} hook never fired, so removing it can't be checked`})
	end

	assert(Fired, `the {Direction} hook wasn't called within 3 seconds`)
	assert(typeof(PacketId) == "number", `expected the packet to have a number PacketId, got {typeof(PacketId)}`)
	assert(MatchedData, "the packet's Size, AsString and AsBuffer don't match each other")

	if not CheckRemove then
		return
	end

	local ControlCount = 0

	const function OnControlPacket()
		ControlCount += 1
	end

	RakNet[`add{Direction}hook`](OnControlPacket)

	AddCleanup(function()
		RakNet[`remove{Direction}hook`](OnControlPacket)
	end)

	WaitFor(function()
		return ControlCount >= 3
	end, 3)

	assert(Count == CountAtRemoval, `the {Direction} hook was still called after it was removed`)
end

const function RunOnNewActor(Code: string): {[string]: any}
	const RunOnActor = Formatters.CheckExist("runonactor")
	const Actor = Instance.new("Actor")

	Actor.Parent = workspace
	AddCleanup(function()
		Actor:Destroy()
	end)

	RunOnActor(Actor, `local Actor = ... {Code} Actor:SetAttribute("Done", true)`, Actor)

	WaitFor(function()
		return Actor:GetAttribute("Done") == true
	end, 2)

	const Attributes = Actor:GetAttributes()

	Actor:Destroy()

	return Attributes
end

const function CheckOffThreadHook()
	const OffThreadHooks = oth
	const Target = math.ldexp

	local InHookThread
	local RootCallback
	local OriginalThread
	local HookThread
	local Original
	local OriginalResult

	AddCleanup(function()
		OffThreadHooks.unhook(Target)
	end)

	Original = OffThreadHooks.hook(Target, function(...)
		OriginalResult = Original(...)
		HookThread = coroutine.running()
		InHookThread = OffThreadHooks.is_hook_thread()
		RootCallback = OffThreadHooks.get_root_callback()
		OriginalThread = OffThreadHooks.get_original_thread()
		return "debUNC Hooked"
	end)

	const HookedResult = Target(1, 2)

	OffThreadHooks.unhook(Target)

	Formatters.CheckReturnType(Original, "function")
	Formatters.CheckEqual(HookedResult, "debUNC Hooked", "the hooked function's result")
	Formatters.CheckEqual(OriginalResult, 4, "the original function's result")
	Formatters.CheckEqual(Target(1, 2), 4, "the result after unhooking")
	assert(InHookThread == true, "is_hook_thread returned false inside the hook")
	assert(OffThreadHooks.is_hook_thread() == false, "is_hook_thread returned true outside of a hook")
	assert(typeof(RootCallback) == "function", `get_root_callback should return a function inside the hook, got {typeof(RootCallback)}`)
	assert(OriginalThread == coroutine.running(), "get_original_thread didn't return the thread that called the function")
	assert(HookThread ~= coroutine.running(), "the hook ran on the same thread as the caller")
	assert(typeof(OriginalThread) == "thread", `get_original_thread should return a thread inside the hook, got {typeof(OriginalThread)}`)

	const NewCClosure = newcclosure

	if not NewCClosure then
		return
	end

	const WrappedTarget = NewCClosure(function()
		return "debUNC Original"
	end)

	AddCleanup(function()
		OffThreadHooks.unhook(WrappedTarget)
	end)

	OffThreadHooks.hook(WrappedTarget, function()
		return "debUNC Hooked"
	end)

	const WrappedResult = WrappedTarget()

	OffThreadHooks.unhook(WrappedTarget)

	Formatters.CheckEqual(WrappedResult, "debUNC Hooked", "the hooked newcclosure function's result")
	Formatters.CheckEqual(WrappedTarget(), "debUNC Original", "the newcclosure function's result after unhooking")
end

const function CheckCommChannel()
	const CreateCommChannel = Formatters.CheckExist("createcommchannel")
	const GetCommChannel = Formatters.CheckExist("getcommchannel")
	const Marker = `debUNC {math.random()}`
	const ChannelId, Channel = CreateCommChannel()

	local Received

	assert(typeof(ChannelId) == "number", `expected a number id, got {typeof(ChannelId)}`)
	assert(GetCommChannel(ChannelId) == Channel, "getcommchannel didn't return the channel that was made")
	Formatters.CheckEqual(GetCommChannel(math.random()), nil, "a channel that was never made")

	Channel.Event:Once(function(...)
		Received = table.pack(...)
	end)

	RunOnNewActor(`getcommchannel({ChannelId}):Fire("{Marker}", game, nil)`)

	WaitFor(function()
		return Received ~= nil
	end, 1)

	assert(Received, "the channel didn't get the message fired from the actor")
	Formatters.CheckEqual(Received[1], Marker, "the message from the actor")
	assert(Received[2] == game, "game sent from the actor didn't arrive as the same game")
	Formatters.CheckEqual(Received.n, 3, "the number of values sent, counting the nil")
end

const function CheckConsole()
	const IsHidden = rconsolehidden
	const Show = rconsoleshow

	if not IsHidden or not Show then
		return
	end

	Formatters.CheckExist("rconsolecreate")()

	AddCleanup(function()
		rconsoledestroy()
	end)

	Show()

	assert(IsHidden() ~= true, "rconsolehidden returned true after rconsoleshow, so the console didn't open")
end

const function CallAsync(Function: (...any) -> ...any, ...: any): ...any
	local Results

	const Thread = task.spawn(function(...)
		Results = table.pack(pcall(Function, ...))
	end, ...)

	assert(coroutine.status(Thread) ~= "dead", "it finished before returning, so it blocks like the normal version instead of running in the background")

	assert(WaitFor(function()
		return Results ~= nil
	end, 5), "it never finished")

	if not Results[1] then
		error(Results[2], 0)
	end

	return table.unpack(Results, 2, Results.n)
end

const function CheckClipboard()
	const GetClipboard = getclipboard

	if not GetClipboard then
		return
	end

	const Text = `debUNC{math.random(1, 1e6)}`

	Formatters.CheckExist("setclipboard")(Text)

	assert(WaitFor(function()
		return GetClipboard() == Text
	end, 1), "the clipboard didn't have the text that was copied")
end

const function CheckScriptThread()
	const GetScriptThread = Formatters.CheckExist("getscriptthread")

	local LocalScript
	local Thread

	for _, Descendant in GetPlayerScripts():GetDescendants() do
		if not Descendant:IsA("LocalScript") then
			continue
		end

		LocalScript = Descendant
		Thread = GetScriptThread(Descendant)

		if Thread then
			break
		end
	end

	if Thread == nil then
		error({Skipped = "no LocalScript has a running thread right now"})
	end

	assert(typeof(Thread) == "thread", `getscriptthread should return a thread, got {typeof(Thread)}`)
	assert(Formatters.CheckExist("getscriptfromthread")(coroutine.running()) == nil, "getscriptfromthread should return nil for the thread running this test")
	assert(Formatters.CheckExist("getscriptfromthread")(Thread) == LocalScript, "getscriptfromthread didn't give back the script the thread belongs to")
end

const function CheckProtoHook()
	const HookProto = Formatters.CheckExist("hookproto")
	const IsProtoHooked = Formatters.CheckExist("isprotohooked")

	const function Outer()
		const function Inner()
			return "debUNC Original"
		end

		return Inner
	end

	const Proto = Formatters.CheckExist("debug.getproto")(Outer, 1)

	assert(IsProtoHooked(Proto) == false, "isprotohooked returned true before the proto was hooked")

	AddCleanup(function()
		if not IsProtoHooked(Proto) then
			return
		end

		restoreproto(Proto)
	end)

	HookProto(Proto, function()
		return "debUNC Hooked"
	end)

	const HookedBefore = IsProtoHooked(Proto)
	const HookedResult = Outer()()

	Formatters.CheckExist("restoreproto")(Proto)

	assert(HookedBefore == true, "isprotohooked returned false after the proto was hooked")
	Formatters.CheckEqual(HookedResult, "debUNC Hooked", "a new closure's result after hooking its proto")
	assert(IsProtoHooked(Proto) == false, "isprotohooked still returned true after restoreproto")
	Formatters.CheckEqual(Outer()(), "debUNC Original", "a new closure's result after restoreproto")
end

const function GetRootPart(): BasePart?
	local RootPart

	WaitFor(function()
		RootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		return RootPart ~= nil
	end, 10)

	assert(RootPart, "your character didn't load within 10 seconds")

	return RootPart
end

const TestImage = buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(
	"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
)))

const function GetAssetStatus(AssetId: string): Enum.AssetFetchStatus?
	const ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Image = AssetId

	local FetchStatus

	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync({ImageLabel}, function(_, Status)
			FetchStatus = Status
		end)
	end)

	ImageLabel:Destroy()

	return FetchStatus
end

const function CheckWrongKey(Crypt: any, Encrypted: string, InitializationVector: string, Text: string)
	const Success, Result = pcall(Crypt.decrypt, Encrypted, Crypt.generatekey(), InitializationVector)

	assert(not Success or Result ~= Text, "decrypting with the wrong key still gave back the original text")
end

const function FindFingerprintHeader(Headers: {[string]: any}): string?
	for Header in Headers do
		if Header:lower():find("fingerprint") then
			return Header
		end
	end

	return nil
end

const function FindConstant(TestedFunction: Function, Value: any): number?
	for Index, Constant in Formatters.CheckExist("debug.getconstants")(TestedFunction) do
		if Constant == Value then
			return Index
		end
	end

	return nil
end

const Tests: any = {
	getrenv = {
		Test = function()
			const Environment = getrenv()

			for _, Global: string in {
				"delay",
				"elapsedTime",
				"printidentity",
				"settings",
				"spawn",
				"stats",
				"tick",
				"time",
				"typeof",
				"UserSettings",
				"version",
				"wait",
				"warn",
				"ypcall",
				"Enum",
				"game",
				"shared",
				"_G",
				"workspace",
			} do
				assert(Environment[Global] ~= nil, `missing '{Global}'`)
			end

			const Value = math.random()

			Environment.debUNC = Value

			const Stored = getrenv().debUNC

			Environment.debUNC = nil

			assert(Environment.game == game, "its 'game' isn't the real game")
			assert(Environment.print == print, "its 'print' isn't the real print")
			assert(Environment._G ~= _G, "its _G is the same as the executor's _G")
			assert(Environment ~= getgenv(), "it's the same table as getgenv(), not Roblox's environment")
			Formatters.CheckEqual(Stored, Value, "a value written to it")
		end,
		ReturnType = "table",
	},

	getgenv = {
		Test = function()
			const Environment = getgenv()
			const Key = `debUNC{math.random(1, 1e6)}`
			const Value = math.random()

			Environment[Key] = Value

			const Seen = loadstring(`return {Key}`)()

			Environment[Key] = nil

			Formatters.CheckEqual(Seen, Value, "a global set in the environment and read by another chunk")

			for FunctionName in getfenv() do
				assert(Environment[FunctionName], `missing '{FunctionName}'`)
			end
		end,
		ReturnType = "table",
	},

	gettenv = {
		Test = function()
			const GetThreadEnvironment: (thread?) -> {[string]: any} = gettenv

			assert(GetThreadEnvironment() == getfenv(), "with no thread given, it should return the current environment like getfenv")

			const Thread = task.spawn(function()
				task.wait(1)
			end)

			AddCleanup(function()
				task.cancel(Thread)
			end)

			const ThreadEnvironment = GetThreadEnvironment(Thread)

			Formatters.CheckReturnType(ThreadEnvironment, "table")

			assert(ThreadEnvironment == getfenv(), "a thread started by this script should have the same environment as it")

			for FunctionName in ThreadEnvironment do
				assert(getfenv()[FunctionName], `the thread environment has '{FunctionName}' but getfenv() doesn't`)
			end
		end,
	},

	readfile = {
		Test = function()
			const ReadFile: (Path: string) -> string = readfile

			assert(not pcall(ReadFile, "doesntexist.txt"), "expected an error when reading a file that doesn't exist")

			const GeneratedResult = `{math.random()}\0debUNC`
			const FileName = `File_{math.random()}.txt`

			Formatters.CheckExist("writefile")(FileName, GeneratedResult)

			const Result = ReadFile(FileName)

			RemovePath("delfile", FileName)

			assert(Result == GeneratedResult, "the test file didn't return what was written into it")
		end,
	},

	writefile = {
		Test = function()
			const GeneratedResult = `{math.random()}\0debUNC`
			const FileName = `File_{math.random()}.txt`

			writefile(FileName, GeneratedResult)

			const Result = Formatters.CheckExist("readfile")(FileName)

			RemovePath("delfile", FileName)

			assert(typeof(Result) == "string", "'readfile' failed to read the file, can't continue the test")
			assert(Result == GeneratedResult, "'writefile' didn't write to the file")
		end,
	},

	isfile = {
		Test = function()
			const FileName = `File_{math.random()}.txt`

			Formatters.CheckExist("writefile")(FileName, "Test")

			const IsFile = isfile
			const Exists = IsFile(FileName)

			RemovePath("delfile", FileName)

			assert(Exists, "failed to find the file")
			assert(IsFile(`Missing_{math.random()}.txt`) == false, "found a file that doesn't exist")
		end,
	},

	appendfile = {
		Test = function()
			const AppendFile: (Path: string, Data: string) -> () = appendfile
			const ReadFile: (Path: string) -> string = Formatters.CheckExist("readfile")

			const GeneratedResult = tostring(math.random())
			const FileName = `File_{math.random()}.txt`

			if not pcall(AppendFile, FileName, GeneratedResult) then
				Formatters.CheckExist("writefile")(FileName, GeneratedResult)
			end

			const Created = ReadFile(FileName) == GeneratedResult

			AppendFile(FileName, "Append")

			const Result = ReadFile(FileName)

			RemovePath("delfile", FileName)

			assert(Created, "failed to create the file")
			Formatters.CheckEqual(Result, `{GeneratedResult}Append`, "the file's text after adding to it")
		end,
	},

	listfiles = {
		Test = function()
			const ListFiles: (Path: string) -> {string} = listfiles

			const FolderName = `Folder_{math.random()}`
			const FileName = `{FolderName}/File_{math.random()}.txt`

			Formatters.CheckExist("makefolder")(FolderName)

			const ReturnedTable = typeof(ListFiles(FolderName)) == "table"

			Formatters.CheckExist("writefile")(FileName, tostring(math.random()))

			const Result = ListFiles(FolderName)

			RemovePath("delfolder", FolderName)

			assert(ReturnedTable, "didn't return a table")
			assert(#Result == 1 and Result[1]:gsub("\\", "/") == FileName, "didn't find the written file")
		end,
	},

	delfile = {
		Test = function()
			const IsFile: (Path: string) -> boolean = Formatters.CheckExist("isfile")

			const FileName = `File_{math.random()}.txt`

			Formatters.CheckExist("writefile")(FileName, "Test")

			assert(IsFile(FileName), "failed to write to the file, can't continue the test")

			delfile(FileName)

			assert(not IsFile(FileName), "'isfile' returned true after the file was meant to be deleted")
		end,
	},

	loadfile = {
		Test = function()
			const FileName = `File_{math.random()}.txt`
			const GeneratedNumber = math.random()

			Formatters.CheckExist("writefile")(FileName, "local Number = ...; return Number + 1")

			const LoadedFunction, ErrorMessage = loadfile(FileName)

			RemovePath("delfile", FileName)

			assert(assert(LoadedFunction, ErrorMessage)(GeneratedNumber) == GeneratedNumber + 1, "didn't return the correct number")
		end,
	},

	makefolder = {
		Test = function()
			const FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			const Exists = Formatters.CheckExist("isfolder")(FolderName) == true

			RemovePath("delfolder", FolderName)

			assert(Exists, "failed to find the folder after it was made")
		end,
	},

	isfolder = {
		Test = function()
			const IsFolder: (Path: string) -> boolean = isfolder

			assert(IsFolder(`Missing_{math.random()}`) == false, "didn't return false for a folder that doesn't exist")

			const FolderName = `Folder_{math.random()}`

			Formatters.CheckExist("makefolder")(FolderName)

			const Exists = IsFolder(FolderName)

			RemovePath("delfolder", FolderName)

			assert(Exists, "the folder wasn't found after it was made")
		end,
	},

	delfolder = {
		Test = function()
			const IsFolder: (Path: string) -> boolean = Formatters.CheckExist("isfolder")

			const FolderName = `Folder_{math.random()}`

			Formatters.CheckExist("makefolder")(FolderName)

			assert(IsFolder(FolderName), "failed to find the folder after it was made")

			delfolder(FolderName)

			assert(not IsFolder(FolderName), "'isfolder' found the folder after it should've been deleted")
		end,
	},

	hookfunction = {
		Test = function()
			const HookFunction: (FunctionToHook: (...any) -> (...any), Hook: (...any) -> ()) -> () -> () = hookfunction
			const NewCClosure: (((...any) -> ...any) -> (...any) -> ...any)? = newcclosure
			const RestoreFunction = restorefunction

			const function HookAndRestore(CClosure: any, Hook: Function, ...): (boolean, any)
				const Original = HookFunction(CClosure, Hook)

				AddCleanup(function()
					if not pcall(RestoreFunction, CClosure) then
						HookFunction(CClosure, Original)
					end
				end)

				const Success, Result = pcall(CClosure, ...)

				RestoreFunction(CClosure)

				return Success, Result
			end

			do
				const function FirstFunction()
					return true
				end

				const Original = HookFunction(FirstFunction, function()
					return false
				end)

				const HookedResult = FirstFunction()

				HookFunction(FirstFunction, Original)

				assert(Original() == true, "the returned function isn't giving the expected result when called")
				assert(HookedResult == false, "the hooked function didn't return the hook's result")
				assert(FirstFunction() == true, "hooking the function back to the returned original didn't restore it")
			end

			do
				const function LuaClosure()
					return true
				end

				HookFunction(LuaClosure, tick)

				assert(type(LuaClosure()) == "number", "expected the LuaClosure to return a number when hooked as 'tick'")
			end

			if NewCClosure then
				const function LuaClosure() end

				HookFunction(LuaClosure, NewCClosure(function()
					return true
				end))

				assert(LuaClosure() == true, "calling the LuaClosure didn't return the NewCClosure's result")
			end

			if RestoreFunction then
				const Success, Result = HookAndRestore(tostring, tonumber, "5")

				assert(Success and Result == 5, "expected tostring to return a number when hooked as tonumber and given '5'")

				const NumberSuccess, NumberResult = HookAndRestore(tonumber, function()
					return true
				end)

				assert(NumberSuccess and NumberResult == true, "expected tonumber to return a boolean when hooked as a LuaClosure that returns true")
			end

			if RestoreFunction and NewCClosure then
				const Success, Result = HookAndRestore(table.create, NewCClosure(function()
					return true
				end))

				assert(Success and Result == true, "expected table.create to return a boolean when hooked as a NewCClosure that returns true")
			end

			if not NewCClosure then
				return
			end

			do
				const FirstNewCClosure = NewCClosure(function() end)

				HookFunction(FirstNewCClosure, NewCClosure(function()
					return true
				end))

				assert(FirstNewCClosure() == true, "expected NewCClosure to return a boolean when hooked as a NewCClosure that returns true")
			end

			do
				const HookedNewCClosure = NewCClosure(function() end)

				HookFunction(HookedNewCClosure, function()
					return true
				end)

				assert(HookedNewCClosure() == true, "expected NewCClosure to return a boolean when hooked as a LuaClosure that returns true")
			end

			const HookedNewCClosure = NewCClosure(function() end)

			HookFunction(HookedNewCClosure, task.wait)

			assert(type(HookedNewCClosure()) == "number", "expected NewCClosure to return a numebr when hooked as task.wait")
		end,
	},

	iscclosure = {
		Test = function()
			const IsCClosure: (Function: (any?) -> ()) -> (boolean) = iscclosure

			assert(IsCClosure(assert) == true, "should return true for assert, which is a C closure")
			assert(IsCClosure(print) == true, "should return true for print, which is a C closure")
			assert(IsCClosure(task.wait) == true, "should return true for task.wait, which is a C closure")
			assert(not IsCClosure(function() end), "should return false for a function made in the executor")
		end,
	},

	clonefunction = {
		Test = function()
			const CloneFunction: ((any?) -> any?) -> ((any?) -> any?) = clonefunction

			const GeneratedNumber = math.random()
			const TestEnvironment = {}

			const function Original()
				return GeneratedNumber
			end

			const PreviousEnvironmentClone = CloneFunction(Original)

			setfenv(Original, TestEnvironment)

			const Clone = CloneFunction(Original)

			assert(Clone ~= Original, "the cloned and original function shouldn't have the same reference")
			assert(Clone() == Original(), "the cloned and original function should return the same value")
			assert(getfenv(Clone) == TestEnvironment, "didn't clone the function's environment")
			assert(getfenv(PreviousEnvironmentClone) ~= TestEnvironment, "the earlier clone picked up the original function's new environment")

			const OriginalInfo = {Formatters.CheckExist("debug.info")(Original, "slna")}
			const ClonedInfo = {Formatters.CheckExist("debug.info")(Clone, "slna")}

			for CheckName, Position in {
				Source = 1,
				Line = 2,
				Name = 3,
				Parameters = 4,
				VariableArguments = 5,
			} do
				assert(
					ClonedInfo[Position] == OriginalInfo[Position],
					`"{CheckName}" isn't the same, it returned "{ClonedInfo[Position]}" instead of "{OriginalInfo[Position]}"`
				)
			end

			const WaitForChild = game.WaitForChild
			const NewWaitForChild = CloneFunction(WaitForChild)

			assert(WaitForChild ~= NewWaitForChild, "the cloned and original C function shouldn't have the same reference")

			const Terrain = workspace:FindFirstChildWhichIsA("Terrain")

			const Succes, Result = pcall(NewWaitForChild, workspace, Terrain.Name :: any)

			assert(Succes, `the new WaitForChild failed with "{Result}"`)
			assert(Result == Terrain, `the new WaitForChild returned "{Result}" instead of "{Terrain.Name}"`)
		end,
	},

	request = {
		Test = function()
			const HttpService = game:GetService("HttpService")
			const Marker = tostring(math.random(1, 1e9))

			const Success, Result = pcall(request, {
				Url = `https://httpbin.org/get?debunc={Marker}`,
				Method = "GET",
				Headers = {["X-Debunc"] = Marker},
			})

			assert(Success, `the request errored with {Result}`)

			Formatters.CheckReturnType(Result, "table")

			assert(Result.StatusCode == 200, `failed to request, got status {Result.StatusCode} {Result.StatusMessage}`)
			assert(Result.StatusMessage == "OK", "StatusMessage should be 'OK' when the StatusCode is 200")
			assert(typeof(Result.Body) == "string", "expected a string from the Body")

			const Decoded = HttpService:JSONDecode(Result.Body)

			Formatters.CheckReturnType(Decoded, "table")

			const Headers = Decoded.headers

			assert(Headers, "the decoded body doesn't contain the headers")
			assert(Headers["X-Debunc"] == Marker, "the header that was sent didn't come back, so the request may not have really gone out")
			assert(Decoded.args and Decoded.args.debunc == Marker, "the query that was sent didn't come back, so the request may not have really gone out")

			const HeaderNames = {}

			for Header in Headers do
				table.insert(HeaderNames, Header)
			end

			assert(FindFingerprintHeader(Headers), `missing the fingerprint (hwid) header, got {table.concat(HeaderNames, ", ")}`)
		end,
		Retry = true,
	},

	require = {
		Test = function()
			const Module = GetPlayerModule()
			const Success, Result = pcall(require, Module)

			assert(Success, `expected success when requiring '{Module.Name}', got the error {Result}`)
			Formatters.CheckReturnType(Result, "table")
			assert(require(Module) == Result, "requiring the same module twice gave different results")
		end,
	},

	fireclickdetector = {
		Test = function()
			const Part = Instance.new("Part")
			const ClickDetector = Instance.new("ClickDetector", Part)

			Part.Anchored = true
			Part.Parent = workspace
			AddCleanup(function()
				Part:Destroy()
			end)

			local WasClicked = false

			ClickDetector.MouseClick:Once(function(ClickingPlayer)
				WasClicked = ClickingPlayer == Player
			end)

			fireclickdetector(ClickDetector)

			const Clicked = WaitFor(function()
				return WasClicked
			end, 1)

			assert(Clicked, "the connection wasn't fired")

			for _, EventName in {"RightMouseClick", "MouseHoverEnter"} do
				local Fired = false

				const Connection = (ClickDetector :: any)[EventName]:Once(function()
					Fired = true
				end)

				fireclickdetector(ClickDetector, 0, EventName)

				const Worked = WaitFor(function()
					return Fired
				end, 1)

				Connection:Disconnect()

				assert(Worked, `{EventName} didn't fire when it was passed as the event`)
			end

			Part:Destroy()
		end,
	},

	fireproximityprompt = {
		Test = function()
			const Part = Instance.new("Part")
			Part.Parent = workspace
			AddCleanup(function()
				Part:Destroy()
			end)

			const ProximityPrompt = Instance.new("ProximityPrompt")
			ProximityPrompt.Parent = Part

			local WasTriggered = false

			ProximityPrompt.Triggered:Once(function(TriggeringPlayer)
				WasTriggered = TriggeringPlayer == Player
			end)

			fireproximityprompt(ProximityPrompt)

			const Triggered = WaitFor(function()
				return WasTriggered
			end, 1)

			Part:Destroy()

			assert(Triggered, "the connection wasn't fired")
		end,
	},

	firesignal = {
		Test = function()
			const NumberValue = Instance.new("NumberValue")
			const GeneratedValue = math.random()

			local DidChange = false

			NumberValue.Changed:Once(function(Value)
				DidChange = Value == GeneratedValue
			end)

			firesignal(NumberValue.Changed, GeneratedValue)

			assert(WaitFor(function()
				return DidChange
			end, 1), "the connection wasn't fired")
		end,
	},

	getloadedmodules = {
		Test = function()
			const LoadedModules = getloadedmodules()

			Formatters.CheckReturnType(LoadedModules, "table")

			const SeenModules = {}

			for _, Module in LoadedModules do
				assert(typeof(Module) == "Instance" and Module:IsA("ModuleScript"), `'{Module}' isn't a ModuleScript`)
				assert(not SeenModules[Module], `'{Module}' is in the returned table more than once`)

				SeenModules[Module] = true
			end

			assert(
				not table.find(LoadedModules, game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("PlayerModule") or false),
				"StarterPlayerScripts.PlayerModule shouldn't be in the returned table"
			)
			assert(
				table.find(LoadedModules, GetPlayerModule()),
				"couldn't find 'PlayerScripts.PlayerModule' in the returned table"
			)

			const Clone = GetPlayerModule().CommonUtils.CameraWrapper:Clone()

			Clone.Parent = Player:FindFirstChild("PlayerScripts") or Player.PlayerGui
			AddCleanup(function()
				Clone:Destroy()
			end)

			const FoundClone = table.find(getloadedmodules(), Clone)

			Clone:Destroy()

			assert(not FoundClone, "found a module that was never required")
		end,
		ReturnType = "table",
	},

	getconnections = {
		Test = function()
			const GetConnections = getconnections
			const NumberValue = Instance.new("NumberValue")
			const GeneratedValue = math.random()

			local DidChange = false
			local Calls = 0
			local WrongValue

			const function OnChanged(Value)
				Calls += 1

				if Value ~= GeneratedValue then
					WrongValue = WrongValue or Value
					return
				end

				DidChange = true
			end

			NumberValue.Changed:Connect(OnChanged)

			const Connections = GetConnections(NumberValue.Changed)

			assert(typeof(Connections) == "table", `expected a table, got {typeof(Connections)}`)
			assert(#Connections == 1, `expected 1 connection in the table, got {#Connections}`)
			assert(Connections[1].Fire, "expected method 'Fire' in the table")
			assert(Connections[1].Function == OnChanged, ".Function isn't the function that was connected")

			Connections[1]:Fire(GeneratedValue)

			assert(WaitFor(function()
				return DidChange
			end, 1), if WrongValue ~= nil then `the connection was fired with the wrong value, expected number '{GeneratedValue}' and got {typeof(WrongValue)} '{WrongValue}'` else "the connection wasn't fired")

			assert(typeof(Connections[1].Thread) == "thread", `.Thread should be a thread, got {typeof(Connections[1].Thread)}`)
			assert(Connections[1].Enabled == true, ".Enabled should be true for an active connection")

			Connections[1]:Disable()

			assert(Connections[1].Enabled == false, ".Enabled should be false after :Disable()")

			const CallsBeforeDisabled = Calls

			NumberValue.Value = GeneratedValue + 1
			task.wait()

			assert(Calls == CallsBeforeDisabled, "the connection still fired after :Disable()")

			Connections[1]:Enable()

			assert(Connections[1].Enabled == true, ".Enabled should be true after :Enable()")

			NumberValue.Value = GeneratedValue + 2

			assert(WaitFor(function()
				return Calls > CallsBeforeDisabled
			end, 1), "the connection didn't fire again after :Enable()")

			Connections[1]:Disconnect()
			DidChange = false
			NumberValue.Value = GeneratedValue

			task.wait()

			assert(not DidChange, "the connection still fired after :Disconnect()")
			assert(#GetConnections(NumberValue.Changed) == 0, "the connection is still listed after :Disconnect()")
		end,
	},

	getscripts = {
		Test = function()
			const Scripts = getscripts()

			assert(table.find(Scripts, GetPlayerModule()), "didn't find PlayerModule")

			for _, CurrentScript: BaseScript | ModuleScript in Scripts do
				assert(typeof(CurrentScript) == "Instance", `expected an instance, got {typeof(CurrentScript)} '{CurrentScript}'`)
				assert(
					CurrentScript:IsA("BaseScript") or CurrentScript:IsA("ModuleScript"),
					`instance '{CurrentScript}' isn't a script, its ClassName is {CurrentScript.ClassName}`
				)
			end
		end,
		ReturnType = "table",
	},

	setfpscap = {
		Test = function()
			const SetFPSCap: (FPSCap: number) -> () = setfpscap

			const function MeasureFPS(): number
				const StartTime = os.clock()

				local Frames = 0

				repeat
					task.wait()
					Frames += 1
				until os.clock() - StartTime >= 1

				return Frames / (os.clock() - StartTime)
			end

			const FPSCap = math.max(math.floor(MeasureFPS() / 4), 5)

			AddCleanup(function()
				SetFPSCap(0)
			end)

			SetFPSCap(FPSCap)

			WaitFor(function()
				const FrameStart = os.clock()

				task.wait()

				return os.clock() - FrameStart >= 0.8 / FPSCap
			end, 2)

			const CappedFPS = MeasureFPS()

			SetFPSCap(0)

			if CappedFPS <= FPSCap * 1.2 and MeasureFPS() <= FPSCap * 1.5 then
				error({Skipped = "the frame rate stayed low after the cap was removed, so the cap can't be told apart from lag", Environment = true})
			end

			assert(
				CappedFPS <= FPSCap * 1.2,
				`the frame rate averaged {math.floor(CappedFPS)} over a second, which is above the cap of {FPSCap}`
			)
		end,
		RunLast = true,
	},

	base64encode = {
		Test = function()
			const GeneratedString = CreateRandomString(math.random(1, 64))

			Formatters.CheckEqual(
				base64encode(GeneratedString),
				buffer.tostring(EncodingService:Base64Encode(buffer.fromstring(GeneratedString))),
				"the encoded random string"
			)
		end,
	},

	loadstring = {
		Test = function()
			const Loaded = loadstring("return 'debunc'")

			assert(typeof(Loaded) == "function", `expected the return type to be a function, got {typeof(Loaded)}`)
			assert(Loaded() == "debunc", "failed to return the expected value")

			const ChunkName = `debUNC{math.random(1, 1e6)}`
			const Compiled, CompileError = loadstring("local x x", ChunkName)

			assert(Compiled == nil, "bad code compiled into a function")
			assert(tostring(CompileError):find(ChunkName, 1, true), `the compile error doesn't mention the chunk name, got '{CompileError}'`)
		end,
	},

	getfpscap = {
		Test = function()
			const GetFPSCap: () -> number = getfpscap
			const SetFPSCap: (FPSCap: number) -> () = Formatters.CheckExist("setfpscap")

			AddCleanup(function()
				SetFPSCap(0)
			end)

			SetFPSCap(10)

			const Result = GetFPSCap()

			SetFPSCap(0)

			Formatters.CheckEqual(Result, 10, "the fps cap")
			assert(GetFPSCap() ~= Result, "set the fps cap to 0 but the result stayed at 10")
		end,
	},

	newcclosure = {
		Test = function()
			const function TestFunction()
				return "debunc"
			end

			const NewClosure = newcclosure(TestFunction)

			assert(Formatters.CheckExist("debug.info")(NewClosure, "s") == "[C]", `expected the returned closure to be in [C], got '{Formatters.CheckExist("debug.info")(NewClosure, "s")}'`)
			assert(NewClosure ~= TestFunction, "the returned function is the same as the function given")
			assert(NewClosure() == "debunc", "failed to return the expected value")
			assert(NewClosure() == "debunc", "failed to return the expected value on the second call")

			Formatters.CheckEqual(newcclosure(function(First, Second)
				task.wait()
				return First + Second
			end)(2, 3), 5, "a wrapped function that yields")
		end,
	},

	isscriptable = {
		Test = function()
			const IsScriptable: (Object: Object, Property: string) -> boolean = isscriptable

			assert(IsScriptable(game, "Parent") == true, "should return true for game.Parent")

			const HiddenSuccess, HiddenResult = pcall(IsScriptable, Instance.new("Fire"), "size_xml")

			assert(not HiddenSuccess or HiddenResult == false, "should return false for Fire.size_xml, which is a hidden property")

			const InvalidSuccess, InvalidResult = pcall(IsScriptable, game, "a")

			assert(not InvalidSuccess or not InvalidResult, "should return false or error for game.a, which isn't a real property")
		end,
	},

	firetouchinterest = {
		Test = function()
			const FireTouchInterest: (FireTouch: BasePart, WithPart: BasePart, Ended: number) -> () = firetouchinterest

			const RootPart = GetRootPart()

			const Pad = Instance.new("Part")

			Pad.Anchored = true
			Pad.CanCollide = false
			Pad.Position = RootPart.Position + Vector3.new(0, 100, 0)
			Pad.Parent = workspace
			AddCleanup(function()
				Pad:Destroy()
			end)

			local Complete = false

			Pad.Touched:Connect(function(Part)
				if RootPart ~= Part then
					return
				end

				Complete = true
			end)

			local Ended = false

			Pad.TouchEnded:Connect(function(Part)
				Ended = Ended or RootPart == Part
			end)

			FireTouchInterest(Pad, RootPart, 0)
			FireTouchInterest(Pad, RootPart, 1)

			const Touched = WaitFor(function()
				return Complete
			end, 5)

			const TouchEnded = WaitFor(function()
				return Ended
			end, 5)

			Pad:Destroy()

			assert(Touched, "failed to fire the touched event within 5 seconds")
			assert(TouchEnded, "failed to fire the touch ended event within 5 seconds")
		end,
	},

	hookmetamethod = {
		Test = function()
			const OriginalIndex = function() end
			const Metatable = setmetatable({}, {__index = OriginalIndex})

			const HookMetamethod = hookmetamethod

			const Original = HookMetamethod(Metatable, "__index", function()
				return "debUNC"
			end)

			Formatters.CheckReturnType(Original, "function")

			const HookedValue = Metatable.yay
			const KeptProto = getmetatable(Metatable).__index == OriginalIndex

			HookMetamethod(Metatable, "__index", Original)

			assert(HookedValue == "debUNC", "indexing the metatable failed to return the hooked value")
			assert(KeptProto, "replaced the metamethod's function instead of its proto")
			assert(Metatable.yay == nil, "hooking __index back to the returned original didn't undo the hook")
		end,
	},

	["debug.info"] = {
		Test = function()
			assert(typeof(debug.info) == "function", "scripts get a debug library without info, so any script using debug.info breaks")
			Formatters.CheckEqual(debug.info(print, "s"), "[C]", "the source of print")
		end,
	},

	setstackhidden = {
		OtherNames = {"sethiddenstack"},
		Test = function()
			const SetStackHidden = setstackhidden or sethiddenstack
			const GetInfo = Formatters.CheckExist("debug.info")

			const function Inner(Mode: string): any
				if Mode == "frames" then
					const Functions = {}

					for Level = 1, 6 do
						const Function = GetInfo(Level, "f")

						if not Function then
							break
						end

						table.insert(Functions, Function)
					end

					return Functions
				end

				if Mode == "traceback" then
					return debug.traceback()
				end

				error("debUNC", 2)
			end

			const function HiddenCaller(Mode: string): any
				return Inner(Mode)
			end

			AddCleanup(function()
				SetStackHidden(HiddenCaller, false)
			end)

			assert(table.find(HiddenCaller("frames"), HiddenCaller), "the function wasn't on the stack before it was hidden")

			SetStackHidden(HiddenCaller, true)

			assert(not table.find(HiddenCaller("frames"), HiddenCaller), "debug.info still found the function on the stack after it was hidden")
			assert(not HiddenCaller("traceback"):find("HiddenCaller", 1, true), "debug.traceback still shows the function after it was hidden")
			Formatters.CheckEqual(select(2, pcall(HiddenCaller, "error")), "debUNC", "the error from a hidden function, which shouldn't have its location")

			SetStackHidden(HiddenCaller, false)

			assert(table.find(HiddenCaller("frames"), HiddenCaller), "the function stayed hidden after setting it back to false")
		end,
	},

	isstackhidden = {
		OtherNames = {"ishiddenstack"},
		Test = function()
			const IsStackHidden = isstackhidden or ishiddenstack
			const SetStackHidden = Formatters.CheckExist("setstackhidden")

			const function Target() end

			AddCleanup(function()
				SetStackHidden(Target, false)
			end)

			Formatters.CheckEqual(IsStackHidden(Target), false, "the result for a function that isn't hidden")

			SetStackHidden(Target, true)

			Formatters.CheckEqual(IsStackHidden(Target), true, "the result after hiding the function")

			SetStackHidden(Target, false)

			Formatters.CheckEqual(IsStackHidden(Target), false, "the result after showing the function again")
		end,
	},

	["DirectoryWatcher.new"] = {
		Test = function()
			const CrashTests = shared.CrashTests or (shared.Settings and shared.Settings.CrashTests)

			if identifyexecutor and identifyexecutor() == "Synapse Z" and not CrashTests then
				error("this crashes Roblox on Synapse Z, so it wasn't run, use shared.CrashTests = true to try it")
			end

			const WriteFile = Formatters.CheckExist("writefile")
			const FolderName = `Folder_{math.random()}`
			const OtherFolderName = `Folder_{math.random()}`
			const FileName = `File_{math.random()}.txt`
			const Changed = {}

			Formatters.CheckExist("makefolder")(FolderName)
			makefolder(OtherFolderName)

			const Watcher = DirectoryWatcher.new(FolderName)

			AddCleanup(function()
				Watcher:Destroy()
			end)

			Watcher.OnChanged:Connect(function(Path)
				table.insert(Changed, tostring(Path))
			end)

			WriteFile(`{OtherFolderName}/{FileName}`, "debUNC")
			WriteFile(`{FolderName}/{FileName}`, "debUNC")

			const Detected = WaitFor(function()
				return #Changed > 0
			end, 2)

			const Count = #Changed
			const Control = DirectoryWatcher.new(FolderName)

			local ControlFired = false

			AddCleanup(function()
				Control:Destroy()
			end)

			Control.OnChanged:Connect(function()
				ControlFired = true
			end)

			Watcher:Destroy()
			WriteFile(`{FolderName}/{FileName}`, "debUNC Again")

			WaitFor(function()
				return ControlFired
			end, 2)

			assert(Detected, "OnChanged didn't fire after a file in the folder was written")
			assert(table.concat(Changed, " "):find(FileName, 1, true), `OnChanged didn't give the changed file's path, got '{table.concat(Changed, ", ")}'`)
			assert(not table.concat(Changed, " "):find(OtherFolderName, 1, true), "OnChanged fired for a file in a different folder")
			Formatters.CheckEqual(#Changed, Count, "the number of changes after Destroy")
		end,
	},

	["WebSocket.connect"] = {
		Test = function()
			const Socket = WebSocket.connect("wss://echo.websocket.org")
			const Marker = `debUNC {math.random()} привет ✓`

			local Messaged = false
			local Closed = false

			const Connection = Socket.OnMessage:Connect(function(Message)
				if Message ~= Marker then
					return
				end

				Messaged = true
			end)

			Socket.OnClose:Once(function()
				Closed = true
			end)

			AddCleanup(function()
				Connection:Disconnect()

				if not Closed then
					Socket:Close()
				end
			end)

			Socket:Send(Marker)

			WaitFor(function()
				return Messaged
			end, 5)

			Connection:Disconnect()
			Socket:Close()

			assert(Messaged, "the echo server didn't send back the message within 5 seconds")
			assert(WaitFor(function()
				return Closed
			end, 1), "OnClose failed to fire when :Close() was called")
		end,
		Retry = true,
	},

	["cache.invalidate"] = {
		Test = function()
			const Container = Instance.new("Folder")
			const Part = Instance.new("Part", Container)

			cache.invalidate(Container:FindFirstChild("Part"))

			assert(not rawequal(Part, Container:FindFirstChild("Part")), "the reference to the part couldn't be invalidated")
		end,
	},

	["cache.iscached"] = {
		Test = function()
			const IsCached = cache.iscached
			const Part = Instance.new("Part")

			assert(IsCached(Part), "the part should be cached")

			Formatters.CheckExist("cache.invalidate")(Part)

			assert(not IsCached(Part), "the part shouldn't be cached")
		end,
	},

	["cache.replace"] = {
		Test = function()
			const Folder = Instance.new("Folder")
			const Part = Instance.new("Part") :: Instance
			const Fire = Instance.new("Fire") :: Instance

			Part.Parent = Folder

			cache.replace(Part, Fire)

			assert(Folder:FindFirstChildWhichIsA("Instance") == Fire, "looking up the part still gave back the part instead of the fire")
		end,
	},

	cloneref = {
		Test = function()
			const Part = Instance.new("Part")
			const ClonedReference = cloneref(Part) :: Part
			const NewPosition = Vector3.new(69, 67, 420)

			assert(typeof(ClonedReference) == "Instance", `expected an Instance, got {typeof(ClonedReference)}`)
			assert(not rawequal(ClonedReference, Part), "the cloned reference shouldn't be the same as the original reference")

			Part.Position = NewPosition

			assert(
				ClonedReference:GetPivot().Position == NewPosition,
				"setting the Position property of the original reference doesn't update the cloned reference"
			)
		end,
	},

	compareinstances = {
		Test = function()
			const Part = Instance.new("Part")
			const Clone = Formatters.CheckExist("cloneref")(Part)

			assert(not rawequal(Part, Clone), "the clone shouldn't be equal to the original")
			assert(compareinstances(Part, Instance.new("Part")) == false, "two different parts shouldn't be equal")
			assert(compareinstances(Part, Clone), "the clone should be equal to the original when using compareinstances()")
		end,
	},

	checkcaller = {
		Test = function()
			const CheckCaller = checkcaller

			assert(CheckCaller() == true, "should return true when called by the executor")

			const FoundModule, CameraModule = pcall(function()
				return GetPlayerModule().CameraModule
			end)

			assert(FoundModule, "BaseCamera doesn't exist, go to a normal game")

			const Success, Camera = pcall(require, CameraModule.BaseCamera)

			assert(Success, `failed to require BaseCamera with the error {Camera}`)

			const Old = Camera.GetSubjectPosition
			local Called: boolean?

			Camera.GetSubjectPosition = function(...)
				Camera.GetSubjectPosition = Old
				Called = CheckCaller()
				return Old(...)
			end

			WaitFor(function()
				return Called ~= nil
			end, 2)

			Camera.GetSubjectPosition = Old

			if Called == nil then
				error({Skipped = "the camera never called the hooked function", Environment = true})
			end

			assert(Called == false, "should return false when called by the CameraModule.BaseCamera")
		end,
	},

	isfunctionhooked = {
		Test = function()
			const IsFunctionHooked: ((...any?) -> ...any?) -> boolean = isfunctionhooked
			const RestoreFunction = restorefunction

			const function Test()
				return "debUNC Original"
			end

			assert(IsFunctionHooked(Test) == false, "an unhooked function should return false")

			Formatters.CheckExist("hookfunction")(Test, function()
				return "debUNC Hooked"
			end)

			assert(IsFunctionHooked(Test) == true, "a hooked function should return true")

			if not RestoreFunction then
				return
			end

			RestoreFunction(Test)

			assert(IsFunctionHooked(Test) == false, "a restored hooked function should return false")
		end,
	},

	base64decode = {
		Test = function()
			const GeneratedString = CreateRandomString(math.random(1, 64))

			Formatters.CheckEqual(
				base64decode(buffer.tostring(EncodingService:Base64Encode(buffer.fromstring(GeneratedString)))),
				GeneratedString,
				"the decoded random string"
			)
		end,
	},

	setrawmetatable = {
		Test = function()
			const LockedProxy = newproxy()

			assert(getmetatable(LockedProxy) == nil, "a new proxy shouldn't have a metatable")

			const MainMetatable = {__call = function()
				return "debUNC"
			end}

			setrawmetatable(LockedProxy, MainMetatable)

			assert(getmetatable(LockedProxy) == MainMetatable, "the new proxy's metatable wasn't set to the expected one")

			const Success, Result = pcall(LockedProxy)

			assert(Success, `errored while calling the new proxy with {Result}`)
			assert(Result == "debUNC", "calling the new proxy failed to return the expected value")
		end,
	},

	lz4compress = {
		Test = function()
			const Compress = lz4compress
			const Repeated = string.rep(CreateRandomString(8), 100)

			assert(Compress("debUNC") == "`debUNC", "failed to compress the string with lz4")
			assert(#Compress(Repeated) < #Repeated / 4, "a string repeated 100 times barely got smaller, so it isn't really compressing")
			Formatters.CheckEqual(Formatters.CheckExist("lz4decompress")(Compress(Repeated), #Repeated), Repeated, "the decompressed string")
		end,
	},

	lz4decompress = {
		Test = function()
			const GeneratedString = CreateRandomString(math.random(16, 256))

			assert(lz4decompress("`debUNC", 6) == "debUNC", "failed to decompress the string with lz4")
			Formatters.CheckEqual(lz4decompress("\x1Aa\x01\x00\x50aaaaa", 20), string.rep("a", 20), "a known compressed block")
			Formatters.CheckEqual(
				lz4decompress(Formatters.CheckExist("lz4compress")(GeneratedString), #GeneratedString),
				GeneratedString,
				"the decompressed random string"
			)
		end,
	},

	["debug.getproto"] = {
		Test = function()
			const Proto = debug.getproto(function()
				const function Inner()
					return "debUNC"
				end
			end, 1)

			assert(Proto, "didn't return anything")

			if typeof(Proto) ~= "function" then
				return
			end

			Formatters.CheckEqual(Formatters.CheckExist("debug.info")(Proto, "n"), "Inner", "the name of the inner function")
		end,
	},

	["debug.getprotos"] = {
		Test = function()
			const Protos = debug.getprotos(function()
				const function First()
					return "debUNC First"
				end

				const function Second()
					return "debUNC Second"
				end
			end)

			Formatters.CheckReturnType(Protos, "table")
			Formatters.CheckEqual(#Protos, 2, "the number of inner functions")

			for Index, Name in {
				"First",
				"Second",
			} do
				if typeof(Protos[Index]) ~= "function" then
					continue
				end

				Formatters.CheckEqual(Formatters.CheckExist("debug.info")(Protos[Index], "n"), Name, "the name of the inner function")
			end
		end,
	},

	getnamecallmethod = {
		Test = function()
			const GetNamecallMethod: () -> string = getnamecallmethod

			const ProxyTest = newproxy(true)
			local Detected

			getmetatable(ProxyTest).__namecall = function()
				Detected = GetNamecallMethod()
			end

			const Method = `debUNC{math.random(1, 1e6)}`
			const Success, Result = pcall(loadstring(`local ProxyTest = ... ProxyTest:{Method}()`) :: Function, ProxyTest)

			assert(Success, `errored while calling the new proxy with namecall, got {Result}`)
			Formatters.CheckEqual(Detected, Method, "the namecall method inside __namecall")
		end,
	},

	getcallingscript = {
		Test = function()
			const Success, CameraWrapper = pcall(require, GetPlayerModule().CommonUtils.CameraWrapper)

			assert(Success, "your executor needs to support 'require' to run this test")

			const GetCameraOriginal = CameraWrapper.getCamera
			local CallingScript
			local Called = false

			CameraWrapper.getCamera = function(...)
				CameraWrapper.getCamera = GetCameraOriginal
				Called = true
				CallingScript = getcallingscript()
				return GetCameraOriginal(...)
			end

			if not WaitFor(function()
				return Called
			end, 2) then
				CameraWrapper.getCamera = GetCameraOriginal
				error({Skipped = "the camera never called the hooked function", Environment = true})
			end

			assert(CallingScript, "returned nil when it should've returned a script")
			assert(
				CallingScript:IsDescendantOf(GetPlayerModule()),
				`the calling script of CameraWrapper.getCamera should be inside of PlayerModule, got '{CallingScript}'`
			)
		end,
	},

	isnetworkowner = {
		RunLast = true,
		Test = function()
			const IsNetworkOwner = isnetworkowner
			const RootPart = GetRootPart()
			assert(IsNetworkOwner(RootPart) == true, "should return true on your HumanoidRootPart")

			for _, Descendant in workspace:GetDescendants() do
				if not Descendant:IsA("BasePart") or not Descendant.Anchored or Descendant:IsDescendantOf(RootPart.Parent :: Instance) then
					continue
				end

				assert(IsNetworkOwner(Descendant) == false, `should return false on '{Descendant:GetFullName()}', an anchored part the server owns`)
				return
			end
		end,
	},

	replicatesignal = {
		Test = function()
			const ReplicateSignal = replicatesignal

			assert(not pcall(ReplicateSignal, workspace.ChildAdded), "should error on a signal that can't be replicated")

			const RootPart = GetRootPart()

			const Character = RootPart.Parent :: Model
			local Died = false

			(Character:FindFirstChildWhichIsA("Humanoid") :: Humanoid).Died:Once(function()
				Died = true
			end)

			ReplicateSignal(Player.Kill)

			assert(WaitFor(function()
				return Died
			end, 5), "you weren't killed within 5 seconds after replicating Player.Kill")

			WaitFor(function()
				const NewCharacter = Player.Character

				return NewCharacter ~= nil and NewCharacter ~= Character and NewCharacter:FindFirstChild("HumanoidRootPart") ~= nil
			end, game:GetService("Players").RespawnTime + 10)
		end,
		RunLast = true,
	},

	["game.HttpGet"] = {
		Test = function()
			const MissingSuccess, MissingResult = pcall(game.HttpGet, game, "https://awqbcduwendewbnzd.aaaaaa")

			assert(
				not MissingSuccess or not MissingResult or MissingResult == "",
				"game:HttpGet on a website that doesn't exist should return an error, nil, or an empty string"
			)

			const Marker = tostring(math.random(1, 1e9))
			const Success, Result = pcall(game.HttpGet, game, `https://httpbin.org/get?debunc={Marker}`)

			assert(Success, `failed to get httpbin with the error {Result}`)

			const DecodeSuccess, Decoded = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), Result)

			assert(DecodeSuccess, "the response wasn't the JSON httpbin sends back")
			assert(Decoded.args and Decoded.args.debunc == Marker, "the query that was sent didn't come back, so the request may not have really gone out")

			local Cached = false

			for _, Page in {
				{Kind = "JSON", Url = `https://httpbin.org/uuid?debunc={math.random(1, 1e9)}`},
				{Kind = "HTML", Url = `https://www.random.org/integers/?num=1&min=1&max=1000000000&col=1&base=10&format=html&rnd=new&debunc={math.random(1, 1e9)}`},
				{Kind = "plain text", Url = `https://www.random.org/integers/?num=1&min=1&max=1000000000&col=1&base=10&format=plain&rnd=new&debunc={math.random(1, 1e9)}`},
			} do
				const First = game:HttpGet(Page.Url)
				const Second = game:HttpGet(Page.Url)
				const NoCacheSuccess, Fresh = pcall(game.HttpGet, game, Page.Url, true)

				assert(NoCacheSuccess, `passing true for NoCache errored with {Fresh}`)
				assert(typeof(Fresh) == "string" and #Fresh > 0, `passing true for NoCache didn't return the {Page.Kind} response`)
				assert(game:HttpGet(Page.Url, true) ~= Fresh, `two {Page.Kind} requests with NoCache set to true gave the same cached response, so true may be treated as cache instead of no cache`)

				if First == Second then
					Cached = true

					assert(Fresh ~= First, `the same {Page.Kind} url gave a cached response even with NoCache set to true`)
				end
			end

			assert(Cached, "requesting the same url twice never gave a cached response, so NoCache has nothing to skip")
		end,
		Retry = true,
	},

	identifyexecutor = {
		Test = function()
			const Name, ExecutorVersion = identifyexecutor()

			assert(typeof(Name) == "string", "the first returned value, the executor's name, should be a string")
			assert(typeof(ExecutorVersion) == "string", "the second returned value, the executor's version, should be a string")
			assert(Name ~= "", "the executor's name is empty")
			assert(ExecutorVersion:find("%d"), `the executor's version should have a number in it, got '{ExecutorVersion}'`)

			assert(
				ExecutorVersion:lower():gsub("^v", "") ~= ({
					Lucid = "1.0.0",
					Bunni = "2.0",
					athena = "1.0",
				})[Name],
				`the version '{ExecutorVersion}' never changes between updates, it should be the real version of each release`
			)
		end,
	},

	gethwid = {
		Test = function()
			const GetHardwareId = gethwid
			const HardwareId = GetHardwareId()
			const Request = request

			assert(typeof(HardwareId) == "string", "the returned value (user's hwid/fingerprint) should be a string")
			assert(HardwareId ~= "", "the hwid is empty")
			assert(GetHardwareId() == HardwareId, "calling it twice gave different hwids")

			if not Request then
				return
			end

			const Success, Result = pcall(Request, {
				Url = "https://httpbin.org/get",
				Method = "GET",
			})

			if not Success then
				return
			end

			const Decoded, Response = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), Result.Body)

			if not Decoded then
				return
			end

			const Header = FindFingerprintHeader(Response.headers)

			if not Header then
				return
			end

			assert(Response.headers[Header] == HardwareId, `the hwid doesn't match the '{Header}' header that request sends`)
		end,
	},

	getrawmetatable = {
		Test = function()
			const GetRawMetatable: (Table: {[any]: any}) -> any = getrawmetatable

			const Detector = newproxy(true)
			const FakeMetatable = {__index = function()
				return true
			end}

			const DetectorMetatable = getmetatable(Detector)
			const IndexFunction = function()
				return (function()
					return error("first debUNC", 2)
				end)()
			end

			DetectorMetatable.__index = IndexFunction
			DetectorMetatable.__metatable = FakeMetatable

			const RawDetectorMetatable = GetRawMetatable(Detector)

			assert(RawDetectorMetatable == GetRawMetatable(Detector), "didn't return the same thing twice")
			assert(RawDetectorMetatable ~= FakeMetatable, "it's just getmetatable under another name")
			assert(RawDetectorMetatable == DetectorMetatable, "failed to return the original metatable")
			assert(rawequal(RawDetectorMetatable, DetectorMetatable), "failed to return the original metatable and tried to fake it")
			assert(not table.isfrozen(RawDetectorMetatable), "returned a read-only metatable")
			assert(IndexFunction == RawDetectorMetatable.__index, "didnt return the original __index")

			const NewIndexFunction = `debUNC {math.random()}`
			DetectorMetatable.__index = NewIndexFunction

			assert(NewIndexFunction == RawDetectorMetatable.__index, `changed __index to {NewIndexFunction} but it still returns the old one`)

			const FirstPart = Instance.new("Part") :: any
			const FirstPartMetatable = GetRawMetatable(FirstPart)

			assert(FirstPartMetatable == GetRawMetatable(Instance.new("Part") :: any), "didn't return the same metatable for unmodified parts")
			assert(table.isfrozen(FirstPartMetatable), "returned a part metatable that isn't read-only")

			for _, MetamethodName in {
				"__index",
				"__newindex",
				"__namecall",
				"__metatable",
			} do
				assert(FirstPartMetatable[MetamethodName], `{MetamethodName} isn't valid in a part`)
			end

			local IndexMetamethod

			xpcall(function()
				return FirstPart[{}]
			end, function()
				IndexMetamethod = Formatters.CheckExist("debug.info")(2, "f")
			end)

			assert(
				FirstPartMetatable.__index == IndexMetamethod,
				`__index gave {FirstPartMetatable.__index} instead of {IndexMetamethod} (__index may not be a CClosure)`
			)
		end,
	},

	["debug.getinfo"] = {
		Test = function()
			const GetInfo = Formatters.CheckExist("debug.getinfo")

			const function DebuncIsBetterThanSunc() end

			const LuaInfo = GetInfo(DebuncIsBetterThanSunc)

			assert(LuaInfo.what == "Lua", ".what should be 'Lua' when used on a Lua function")
			assert(LuaInfo.name == "DebuncIsBetterThanSunc", ".name should match the name of the Lua function")

			const CInfo = GetInfo(task.wait)

			assert(CInfo.what == "C", ".what should be 'C' when used on task.wait")
			assert(CInfo.name == "wait", ".name should be 'wait' when used on task.wait")

			const function WithArguments(First, Second, ...) end

			const Arguments = GetInfo(WithArguments)

			assert(Arguments.func == WithArguments, ".func should be the function")
			Formatters.CheckEqual(Arguments.numparams, 2, ".numparams")
			Formatters.CheckEqual(Arguments.is_vararg, 1, ".is_vararg")
		end,
	},

	setreadonly = {
		Test = function()
			const SetReadOnly: (Table: any, ReadOnly: boolean) -> () = setreadonly
			const ReadOnlyTable = ColorSequence :: any

			const function ReadOnlyEditTest()
				if not pcall(function()
					ReadOnlyTable[1] = "debUNC"
				end) then
					return false
				end

				pcall(function()
					ReadOnlyTable[1] = nil
				end)

				return true
			end

			assert(table.isfrozen(ReadOnlyTable), "ColorSequence isn't frozen")
			assert(not ReadOnlyEditTest(), "shouldn't be able to write to ColorSequence while it's frozen")

			AddCleanup(function()
				table.freeze(ReadOnlyTable)
			end)

			SetReadOnly(ReadOnlyTable, false)

			const WriteSuccess, WriteError = pcall(function()
				ReadOnlyTable[123] = "debUNC"
			end)

			pcall(function()
				ReadOnlyTable[123] = nil
			end)

			const Unfrozen = not table.isfrozen(ReadOnlyTable)

			SetReadOnly(ReadOnlyTable, true)

			const StillWritable = ReadOnlyEditTest()

			if StillWritable then
				pcall(table.freeze, ReadOnlyTable)
			end

			assert(WriteSuccess, `failed to write after unfreezing, got {WriteError}`)
			assert(Unfrozen, "the table still looks frozen after unfreezing")
			assert(not StillWritable, "the table didn't become read-only again")
		end,
	},

	getsenv = {
		Test = function()
			const GetScriptEnvironment: (Script: LocalScript) -> any = getsenv
			const PlayerScripts = GetPlayerScripts()
			const Value = math.random()

			const function CreateNewModuleTest(SetParent: boolean)
				const New = PlayerScripts.RbxCharacterSounds:Clone()
				const AtomicBinding = New:FindFirstChildWhichIsA("ModuleScript")

				assert(AtomicBinding, "failed to find the 'AtomicBinding' ModuleScript in the cloned RbxCharacterSounds")

				local Called = false

				require(AtomicBinding).new = function()
					if SetParent then
						New.Parent = nil
					end

					Called = true
					getfenv(2).debUNC = Value

					return task.wait(9e9)
				end

				New.Parent = Player:FindFirstChild("PlayerScripts") or Player.PlayerGui
				AddCleanup(function()
					New:Destroy()
				end)

				return WaitFor(function()
					return Called
				end, 2), New
			end

			const Called, NewSoundsScript = CreateNewModuleTest(false)
			const ScriptEnvironment = Called and GetScriptEnvironment(NewSoundsScript)

			NewSoundsScript:Destroy()

			assert(Called, "the script took too long to respond")
			assert(ScriptEnvironment, "getsenv returned nil")
			assert(ScriptEnvironment.script == NewSoundsScript, ".script doesn't point to the script being used in the function call")
			Formatters.CheckEqual(ScriptEnvironment.debUNC, Value, "a global set by the running script")

			const NilParentCalled, NewSoundsNilScript = CreateNewModuleTest(true)
			const NilParentEnvironment = NilParentCalled and GetScriptEnvironment(NewSoundsNilScript)

			NewSoundsNilScript:Destroy()

			assert(NilParentCalled, "the script took too long to respond when its parent was nil")
			assert(NilParentEnvironment, "getsenv returned nil when the parent was nil")
		end,
	},

	decompile = {
		Test = function()
			const Decompile = decompile
			const GetScriptClosure = getscriptclosure
			const CameraModule = GetPlayerModule().CameraModule
			const Result = Decompile(CameraModule)

			Formatters.CheckReturnType(Result, "string")

			assert(not Result:find("\0", 1, true), "the result has null bytes, so it isn't readable code")
			assert(Result:find("__index"), `couldn't find '__index' in the decompiled 'CameraModule', it started with '{Result:sub(1, 300)}'`)
			assert(Decompile(CameraModule.Parent.ControlModule) ~= Result, "'CameraModule' and 'ControlModule' decompiled to the same thing")

			if not GetScriptClosure then
				return
			end

			for _, Constant in Formatters.CheckExist("debug.getconstants")(GetScriptClosure(CameraModule)) do
				if typeof(Constant) ~= "string" or #Constant < 5 or not Constant:match("^[%w_]+$") then
					continue
				end

				assert(Result:find(Constant, 1, true), `couldn't find the string '{Constant}' from the script's own constants in the decompiled 'CameraModule'`)
			end
		end,
	},

	mouse1click = {
		Test = function()
			CheckMouseButton(1, "mouse1click")
		end,
		RunLast = true,
	},

	mouse1press = {
		Test = function()
			CheckMouseButton(1, "mouse1press")
		end,
		RunLast = true,
	},

	mouse1release = {
		Test = function()
			CheckMouseButton(1, "mouse1release")
		end,
		RunLast = true,
	},

	mouse2click = {
		Test = function()
			CheckMouseButton(2, "mouse2click")
		end,
		RunLast = true,
	},

	mouse2press = {
		Test = function()
			CheckMouseButton(2, "mouse2press")
		end,
		RunLast = true,
	},

	mouse2release = {
		Test = function()
			CheckMouseButton(2, "mouse2release")
		end,
		RunLast = true,
	},

	mousemoveabs = {
		Test = function()
			CheckInputFree()

			const Center = workspace.CurrentCamera.ViewportSize / 2

			const function MoveTo(Target: Vector2): Vector2
				const Before = UserInputService:GetMouseLocation()

				mousemoveabs(Target.X, Target.Y)

				WaitFor(function()
					return UserInputService:GetMouseLocation() ~= Before
				end, 1)

				return UserInputService:GetMouseLocation()
			end

			const FirstTarget = Center - Vector2.new(math.random(30, 60), math.random(30, 60))
			const SecondTarget = Center + Vector2.new(math.random(30, 60), math.random(30, 60))
			const LastTarget = Center + Vector2.new(math.random(-50, 50), math.random(-50, 50))
			const First = MoveTo(FirstTarget)
			const Second = MoveTo(SecondTarget)
			const Scale = (Second - First) / (SecondTarget - FirstTarget)

			assert(
				Scale.X > 0 and math.abs(Scale.X - Scale.Y) < Scale.X * 0.02,
				`the mouse went to {First} then {Second}, which doesn't match moving to {FirstTarget} then {SecondTarget}`
			)

			const Expected = First + (LastTarget - FirstTarget) * Scale.X
			const Last = MoveTo(LastTarget)

			assert((Last - Expected).Magnitude < 2, `the mouse went to {Last} instead of {Expected}`)
		end,
		RunLast = true,
	},

	mousemoverel = {
		Test = function()
			CheckInputFree()
			CenterMouse()

			const function MoveBy(Amount: number): Vector2
				const Before = UserInputService:GetMouseLocation()

				mousemoverel(Amount, Amount)

				WaitFor(function()
					return UserInputService:GetMouseLocation() ~= Before
				end, 1)

				return UserInputService:GetMouseLocation() - Before
			end

			const FirstMove = MoveBy(25)
			const SecondMove = MoveBy(50)

			assert(
				FirstMove.X > 0 and math.abs(FirstMove.X - FirstMove.Y) < 2 and (SecondMove - FirstMove * 2).Magnitude < 3,
				`the mouse moved by {FirstMove} then {SecondMove}, but moving by 25 then 50 should go the same way twice as far`
			)
		end,
		RunLast = true,
	},

	mousescroll = {
		Test = function()
			CheckInputFree()

			const MouseMoveAbsolute = mousemoveabs

			if MouseMoveAbsolute then
				const Target = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, 65)

				MouseMoveAbsolute(Target.X, Target.Y)

				WaitFor(function()
					return (UserInputService:GetMouseLocation() - Target).Magnitude < 2
				end, 2)
			end

			const MouseScroll = mousescroll

			const Detected = WaitForInput(UserInputService.InputChanged, function(Input)
				return Input.UserInputType == Enum.UserInputType.MouseWheel and Input.Position.Z > 0
			end, function()
				MouseScroll(120)
			end)

			const DetectedDown = WaitForInput(UserInputService.InputChanged, function(Input)
				return Input.UserInputType == Enum.UserInputType.MouseWheel and Input.Position.Z < 0
			end, function()
				MouseScroll(-120)
			end)

			assert(Detected, "the scroll up wasn't detected")
			assert(DetectedDown, "the scroll down wasn't detected")
		end,
		RunLast = true,
	},

	keypress = {
		Test = function()
			CheckKey("keypress")
		end,
		RunLast = true,
	},

	keyrelease = {
		Test = function()
			CheckKey("keyrelease")
		end,
		RunLast = true,
	},

	sethiddenproperty = {
		Test = function()
			const Fire = Instance.new("Fire")
			const NewValue = math.random(6, 20)
			const Part = Instance.new("Part")

			sethiddenproperty(Part, "Transparency", 0.5)

			Formatters.CheckEqual(Part.Transparency, 0.5, "a part's Transparency")

			sethiddenproperty(Fire, "size_xml", NewValue)

			Formatters.CheckEqual(Formatters.CheckExist("gethiddenproperty")(Fire, "size_xml"), NewValue, "size_xml")
		end,
	},

	gethiddenproperty = {
		Test = function()
			const Fire = Instance.new("Fire")
			const Size = math.random(6, 20)

			Fire.Size = Size

			Formatters.CheckEqual(gethiddenproperty(Fire, "size_xml"), Size, "size_xml")
		end,
	},

	setscriptable = {
		Test = function()
			const SetScriptable = setscriptable
			const Fire = Instance.new("Fire")

			const function CanRead()
				return pcall(function()
					return (Fire :: any).size_xml
				end)
			end

			const ReadBefore = CanRead()

			SetScriptable(Fire, "size_xml", true)

			const ReadWhileOn = CanRead()

			SetScriptable(Fire, "size_xml", false)

			assert(not ReadBefore, "size_xml could be read before it was made scriptable")
			assert(ReadWhileOn, "size_xml couldn't be read after it was made scriptable")
			assert(not CanRead(), "size_xml could still be read after it was made unscriptable")
		end,
	},

	getthreadidentity = {
		Test = function()
			const GetThreadIdentity = getthreadidentity
			const SetThreadIdentity = Formatters.CheckExist("setthreadidentity")
			const Original = GetThreadIdentity()

			coroutine.resume(coroutine.create(function()
				SetThreadIdentity(3)
			end))

			Formatters.CheckEqual(GetThreadIdentity(), Original, "this thread's identity after another thread changed its own")

			local PrintedIdentity

			const Connection = game:GetService("LogService").MessageOut:Connect(function(Message)
				PrintedIdentity = PrintedIdentity or tonumber(Message:match("Current identity is (%d+)"))
			end)

			AddCleanup(function()
				Connection:Disconnect()
			end)

			SetThreadIdentity(2)

			const Result = GetThreadIdentity()

			printidentity()

			SetThreadIdentity(Original)

			WaitFor(function()
				return PrintedIdentity ~= nil
			end, 1)

			Connection:Disconnect()

			Formatters.CheckEqual(Result, 2, "the identity")

			if PrintedIdentity == nil then
				return
			end

			Formatters.CheckEqual(Result, PrintedIdentity, "the identity Roblox's printidentity() shows")
		end,
	},

	setthreadidentity = {
		Test = function()
			const SetThreadIdentity = setthreadidentity
			const Original = Formatters.CheckExist("getthreadidentity")()
			const CoreGui = game:GetService("CoreGui")

			const function CanReadCoreGui()
				return pcall(function()
					return CoreGui:GetChildren()
				end)
			end

			SetThreadIdentity(2)

			const ReadAtTwo = CanReadCoreGui()

			SetThreadIdentity(8)

			const ReadAtEight = CanReadCoreGui()

			SetThreadIdentity(Original)

			assert(not ReadAtTwo, "CoreGui could still be read at identity 2")
			assert(ReadAtEight, "CoreGui couldn't be read at identity 8")
		end,
	},

	restorefunction = {
		Test = function()
			const function Test()
				return "debUNC Original"
			end

			Formatters.CheckExist("hookfunction")(Test, function()
				return "debUNC Hooked"
			end)

			assert(Test() == "debUNC Hooked", "hookfunction didn't hook the function, can't continue the test")

			restorefunction(Test)

			assert(Test() == "debUNC Original", "the function didn't return its original value after being restored")
		end,
	},

	filtergc = {
		Test = function()
			const FilterGc = filtergc
			const Key = `debUNC {math.random()}`
			const Table = {[Key] = true}

			const function TestFunction()
				return Key
			end

			const PairKey = `debUNC pair {math.random()}`
			const PairValue = `debUNC value {math.random()}`
			const Metatable = {}
			const Marked = setmetatable({[PairKey] = PairValue}, Metatable)

			assert(FilterGc("table", {Keys = {Key}}, true) == Table, "didn't find the table by its key")
			assert(table.find(FilterGc("table", {Values = {PairValue}}), Marked), "didn't find the table by its value")
			assert(table.find(FilterGc("table", {KeyValuePairs = {[PairKey] = PairValue}}), Marked), "didn't find the table by its key and value pair")
			assert(table.find(FilterGc("table", {Metatable = Metatable}), Marked), "didn't find the table by its metatable")
			Formatters.CheckEqual(#FilterGc("table", {Keys = {Key}}), 1, "the number of tables with that key")
			assert(table.find(FilterGc("function", {
				Name = "TestFunction",
				IgnoreExecutor = false,
			}), TestFunction), "didn't find the function by its name")
		end,
	},

	getmenv = {
		Test = function()
			const CameraWrapper = GetPlayerModule().CommonUtils.CameraWrapper
			const GetCamera = require(CameraWrapper).getCamera
			const Environment = getmenv(CameraWrapper)

			Formatters.CheckReturnType(Environment, "table")

			assert(Environment.script == CameraWrapper, ".script doesn't point to the module")
			assert(Environment == getfenv(GetCamera), "didn't return the environment that the module's functions use")
		end,
	},

	makewriteable = {
		Test = function()
			const Table = table.freeze({})

			makewriteable(Table)

			assert(not table.isfrozen(Table), "the table is still frozen")
			assert(pcall(function()
				Table.debUNC = true
			end), "couldn't write to the table")
		end,
	},

	["debug.getstack"] = {
		Test = function()
			const function Test()
				local Secret = math.random(1, 1e6) + 0.5

				return table.find(debug.getstack(1), Secret), Secret
			end

			assert(Test(), "couldn't find a local in the stack")
		end,
	},

	["debug.setstack"] = {
		Test = function()
			const function Test()
				local Secret = math.random(1, 1e6) + 0.5
				const Expected = Secret + 1
				const Index = table.find(Formatters.CheckExist("debug.getstack")(1), Secret)

				assert(Index, "couldn't find the local in the stack")

				debug.setstack(1, Index, Expected)

				return Secret, Expected
			end

			const Result, Expected = Test()

			assert(Result == Expected, `the local should've changed to {Expected}, got {Result}`)
		end,
	},

	["debug.getupvalues"] = {
		Test = function()
			const First, Second = {}, {}

			const function Test()
				error("debUNC")
				return First, Second
			end

			const Upvalues = debug.getupvalues(Test)

			assert(table.find(Upvalues, First) and table.find(Upvalues, Second), "didn't find both upvalues")
		end,
	},

	["debug.getupvalue"] = {
		Test = function()
			const First, Second = {}, {}

			const function Test()
				error("debUNC")
				return First, Second
			end

			const GetUpvalue = debug.getupvalue

			assert(GetUpvalue(Test, 1) == First, "didn't return the first upvalue")
			assert(GetUpvalue(Test, 2) == Second, "didn't return the second upvalue")
		end,
	},

	["debug.setupvalue"] = {
		Test = function()
			local Upvalue = {}

			const function Test()
				return Upvalue
			end

			const function Other()
				Upvalue = Upvalue
				return Upvalue
			end

			debug.setupvalue(Test, 1, "debUNC")

			assert(Test() == "debUNC", "the upvalue wasn't changed")
			assert(Other() == "debUNC", "another function using the same upvalue didn't see the change")
		end,
	},

	["debug.getconstants"] = {
		Test = function()
			const Constant = `debUNC{math.random(1, 1e6)}`
			const Test = loadstring(`print("{Constant}")`) :: Function

			Formatters.CheckReturnType(debug.getconstants(Test), "table")

			assert(FindConstant(Test, Constant), "didn't find the string constant")
		end,
	},

	["debug.getconstant"] = {
		Test = function()
			const Constant = `debUNC{math.random(1, 1e6)}`
			const Test = loadstring(`print("{Constant}")`) :: Function

			Formatters.CheckEqual(debug.getconstant(Test, FindConstant(Test, Constant)), Constant, "the string constant")
		end,
	},

	["debug.setconstant"] = {
		Test = function()
			const Test = loadstring("local Value = ... return `debUNC Before {Value}`") :: Function
			const Other = loadstring("local Value = ... return 'debUNC Before' .. Value") :: Function

			debug.setconstant(Other, FindConstant(Other, "debUNC Before"), "debUNC After")

			assert(Test("x") == "debUNC Before x", "changing a constant affected a different function")
			Formatters.CheckEqual(Other("x"), "debUNC Afterx", "the function's result with the changed constant")
		end,
	},

	["debug.getregistry"] = {
		Test = function()
			const Values = debug.getregistry()

			Formatters.CheckReturnType(Values, "table")

			local HasThread = false

			for _, Value in Values do
				if typeof(Value) ~= "thread" then
					continue
				end

				HasThread = true
				break
			end

			assert(HasThread, "the registry should hold at least one thread")
		end,
	},

	["crypt.hash"] = {
		Test = function()
			const Hash = crypt.hash
			const GeneratedString = CreateRandomString(math.random(1, 64))
			const RandomHash = Hash(GeneratedString, "sha256")

			assert(
				Hash("abc", "sha256"):lower() == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
				`the sha256 hash of 'abc' was wrong, got {Hash("abc", "sha256")}`
			)
			assert(RandomHash:match("^%x+$") and #RandomHash == 64, `a sha256 hash should be 64 hex characters, got '{RandomHash}'`)
			assert(Hash(GeneratedString, "sha256") == RandomHash, "hashing the same random string twice gave different results")
			assert(Hash(`{GeneratedString}x`, "sha256") ~= RandomHash, "two different strings gave the same hash")

			const Expected = EncodingService:ComputeBufferHash(buffer.fromstring(GeneratedString), Enum.HashAlgorithm.Sha256)

			Formatters.CheckEqual(
				RandomHash:lower(),
				buffer.tostring(Expected):gsub(".", function(Character)
					return string.format("%02x", Character:byte())
				end),
				"the sha256 hash of a random string"
			)
		end,
	},

	["crypt.generatekey"] = {
		Test = function()
			const Key = crypt.generatekey()

			assert(#Formatters.CheckExist("base64decode")(Key) == 32, "the decoded key should be 32 bytes")
			assert(Key ~= crypt.generatekey(), "generated the same key twice")
		end,
	},

	["crypt.generatebytes"] = {
		Test = function()
			const Length = math.random(8, 64)

			assert(#Formatters.CheckExist("base64decode")(crypt.generatebytes(Length)) == Length, `the decoded bytes should be {Length} long`)
		end,
	},

	["crypt.encrypt"] = {
		Test = function()
			const Crypt = crypt
			const Key = Crypt.generatekey()
			const Text = `debUNC {math.random()}`
			const Encrypted, InitializationVector = Crypt.encrypt(Text, Key)

			assert(not Encrypted:find(Text, 1, true), "the encrypted text still has the original text in it")
			assert(Crypt.decrypt(Encrypted, Key, InitializationVector) == Text, "decrypting didn't give back the original text")
			assert(Crypt.encrypt(Text, Key) ~= Encrypted, "encrypting the same text twice gave the same result, so it isn't using a new iv each time")

			CheckWrongKey(Crypt, Encrypted, InitializationVector, Text)
		end,
	},

	["Drawing.new"] = {
		Test = function()
			const Line = Drawing.new("Line")
			AddCleanup(function()
				Line:Remove()
			end)

			assert(not pcall(Drawing.new, "debUNC"), "should error on a type that doesn't exist")
			assert(not pcall(function()
				Line.Thickness = "debUNC"
			end), "should error when Thickness is set to a string")

			const Thickness = Line.Thickness
			const Visible = Line.Visible
			const Existed = Line.__OBJECT_EXISTS
			const Text = Drawing.new("Text")

			AddCleanup(function()
				Text:Remove()
			end)

			Text.Font = 3

			const AppliedFont = Text.Font

			Line:Remove()
			Text:Remove()

			Formatters.CheckEqual(AppliedFont, 3, "a Text object's Font after setting it to 3")
			assert(typeof(Thickness) == "number", "Thickness should be a number")
			assert(typeof(Visible) == "boolean", "Visible should be a boolean")
			assert(Existed == true, "__OBJECT_EXISTS should be true before :Remove()")
			assert(Line.__OBJECT_EXISTS == false, "__OBJECT_EXISTS should be false after :Remove()")
		end,
	},

	isrenderobj = {
		Test = function()
			const IsRenderObject = isrenderobj
			const Line = Formatters.CheckExist("Drawing.new")("Line")
			AddCleanup(function()
				Line:Remove()
			end)

			const Result = IsRenderObject(Line)

			Line:Remove()

			assert(Result == true, "should return true for a drawing object")
			assert(IsRenderObject({}) == false, "should return false for a table")
			assert(IsRenderObject(Instance.new("Part")) == false, "should return false for an Instance")
			assert(IsRenderObject(5) == false, "should return false for a number")
		end,
	},

	getrenderproperty = {
		Test = function()
			const Line = Formatters.CheckExist("Drawing.new")("Line")
			AddCleanup(function()
				Line:Remove()
			end)
			const Thickness = math.random(2, 9)

			Line.Thickness = Thickness

			const Result = getrenderproperty(Line, "Thickness")

			Line:Remove()

			Formatters.CheckEqual(Result, Thickness, "Thickness")
		end,
	},

	setrenderproperty = {
		Test = function()
			const Line = Formatters.CheckExist("Drawing.new")("Line")
			AddCleanup(function()
				Line:Remove()
			end)
			const Thickness = math.random(2, 9)

			setrenderproperty(Line, "Thickness", Thickness)

			const Result = Line.Thickness

			Line:Remove()

			Formatters.CheckEqual(Result, Thickness, "Thickness")
		end,
	},

	cleardrawcache = {
		Test = function()
			const Line = Formatters.CheckExist("Drawing.new")("Line")
			AddCleanup(function()
				Line:Remove()
			end)

			cleardrawcache()

			assert(Line.__OBJECT_EXISTS == false, "the drawing object still exists")
		end,
	},

	runonthread = {
		Test = function()
			const Thread = task.spawn(function()
				task.wait(2)
			end)

			const Value = math.random()

			runonthread(Thread, `shared.debUNCThreadValue = {Value}`)

			const Ran = WaitFor(function()
				return shared.debUNCThreadValue == Value
			end, 1)

			shared.debUNCThreadValue = nil
			task.cancel(Thread)

			assert(Ran, "the code didn't run on the thread")
		end,
	},

	runonactor = {
		Test = function()
			const Value = math.random()

			assert(RunOnNewActor(`Actor:SetAttribute("Value", {Value})`).Value == Value, "the code didn't run on the actor")
		end,
	},

	getactors = {
		Test = function()
			const RunOnActor = Formatters.CheckExist("runonactor")
			const GetActorFromThread = getactorfromthread
			const Actor = Instance.new("Actor")

			Actor.Parent = workspace
			AddCleanup(function()
				Actor:Destroy()
			end)

			const CountBefore = #getactors()

			RunOnActor(Actor, "")

			local Actors

			const function FindNewActor(): boolean
				for _, Value in Actors do
					if Value == Actor or (typeof(Value) == "thread" and GetActorFromThread and GetActorFromThread(Value) == Actor) then
						return true
					end
				end

				return typeof(Actors[1]) == "thread" and #Actors > CountBefore
			end

			const Found = WaitFor(function()
				Actors = getactors()
				return FindNewActor()
			end, 2)

			Actor:Destroy()

			for _, Value in Actors do
				assert(
					typeof(Value) == "thread" or (typeof(Value) == "Instance" and Value:IsA("Actor")),
					`should return Actors or actor threads, but got {if typeof(Value) == "Instance" then Value.ClassName else typeof(Value)}`
				)
			end

			assert(Found, "didn't find the new actor")
		end,
	},

	getactorthreads = {
		Test = function()
			RunOnNewActor("")

			const Threads = getactorthreads()

			Formatters.CheckReturnType(Threads, "table")

			assert(#Threads > 0, "expected at least one actor thread")
			assert(not table.find(Threads, coroutine.running()), "the thread running this test isn't on an actor")

			for _, Thread in Threads do
				assert(typeof(Thread) == "thread", `expected threads, got {typeof(Thread)}`)
			end
		end,
	},

	isparallel = {
		Test = function()
			assert(isparallel() == false, "should return false outside of an actor")
			assert(RunOnNewActor("Actor:SetAttribute('Parallel', isparallel())").Parallel == false, "should return false in an actor before it desynchronizes")
			assert(
				RunOnNewActor("task.desynchronize() local Result = isparallel() task.synchronize() Actor:SetAttribute('Parallel', Result)").Parallel == true,
				"should return true in a desynchronized actor"
			)
		end,
	},

	getgc = {
		Test = function()
			const Holder = {Table = {}, Function = function() end}
			const GarbageCollected = getgc(true)

			Formatters.CheckReturnType(GarbageCollected, "table")

			assert(table.find(GarbageCollected, Holder.Function), "didn't find a new function")
			assert(table.find(GarbageCollected, Holder.Table), "didn't find a new table when including tables")
		end,
	},

	getinstances = {
		Test = function()
			const Holder = {Part = Instance.new("Part")}

			assert(table.find(getinstances(), Holder.Part), "didn't find a new part")
		end,
	},

	getnilinstances = {
		Test = function()
			const Holder = {NilPart = Instance.new("Part")}
			const ParentedPart = Instance.new("Part")
			ParentedPart.Parent = workspace
			AddCleanup(function()
				ParentedPart:Destroy()
			end)

			const NilInstances = getnilinstances()

			ParentedPart:Destroy()

			assert(table.find(NilInstances, Holder.NilPart), "didn't find a part parented to nil")
			assert(not table.find(NilInstances, ParentedPart), "found a part that was parented to workspace")
		end,
	},

	getrunningscripts = {
		Test = function()
			const Disabled = GetPlayerScripts():FindFirstChildWhichIsA("LocalScript", true):Clone()

			Disabled.Disabled = true
			Disabled.Parent = Player:FindFirstChild("PlayerScripts") or Player.PlayerGui
			AddCleanup(function()
				Disabled:Destroy()
			end)

			const RunningScripts = getrunningscripts()
			const FoundDisabled = table.find(RunningScripts, Disabled)

			Disabled:Destroy()

			assert(not FoundDisabled, "found a disabled script")

			local FoundRunning = false

			for _, Descendant in GetPlayerScripts():GetDescendants() do
				if Descendant:IsA("LocalScript") and table.find(RunningScripts, Descendant) then
					FoundRunning = true
					break
				end
			end

			assert(FoundRunning, "didn't find a running LocalScript")

			const SeenScripts = {}

			for _, RunningScript in RunningScripts do
				assert(RunningScript:IsA("LuaSourceContainer"), `'{RunningScript}' isn't a script`)
				assert(not SeenScripts[RunningScript], `'{RunningScript}' is in the returned table more than once`)

				SeenScripts[RunningScript] = true
			end
		end,
	},

	getscriptbytecode = {
		Test = function()
			const GetScriptBytecode = getscriptbytecode
			const PlayerModule = GetPlayerModule()
			const Bytecode = GetScriptBytecode(PlayerModule)

			Formatters.CheckReturnType(Bytecode, "string")

			assert(#Bytecode > 0, "the bytecode is empty")
			assert(GetScriptBytecode(PlayerModule.CameraModule) ~= Bytecode, "'PlayerModule' and 'CameraModule' gave the same bytecode")
		end,
	},

	getscripthash = {
		Test = function()
			const GetScriptHash = getscripthash
			const LocalScript = GetPlayerScripts():FindFirstChildWhichIsA("LocalScript", true)
			const Hash = GetScriptHash(LocalScript)

			Formatters.CheckReturnType(Hash, "string")

			assert(#Hash > 0, "the hash is empty")
			assert(GetScriptHash(LocalScript) == Hash, "hashing the same script twice gave different results")
			assert(GetScriptHash(GetPlayerModule()) ~= Hash, "two different scripts gave the same hash")
			assert(#Hash == 96 and Hash:match("^%x+$"), `should be a 96 character sha384 hash, got {#Hash} characters`)

			const Crypt = crypt
			const GetScriptBytecode = getscriptbytecode

			if not Crypt or not GetScriptBytecode then
				return
			end

			const Supported, IsSha384 = pcall(function()
				return #Crypt.hash("abc", "sha384") == 96
			end)

			if not Supported or not IsSha384 then
				return
			end

			assert(Hash == Crypt.hash(GetScriptBytecode(LocalScript), "sha384"), "the hash isn't the sha384 of the script's bytecode")
		end,
	},

	getscriptclosure = {
		Test = function()
			const LocalScript = GetPlayerScripts():FindFirstChildWhichIsA("LocalScript", true)
			const Closure = getscriptclosure(LocalScript)

			Formatters.CheckReturnType(Closure, "function")

			assert(getfenv(Closure).script == LocalScript, "the closure's script doesn't match")
		end,
	},

	gethui = {
		Test = function()
			const HiddenGui = gethui()
			const ScreenGui = Instance.new("ScreenGui")
			ScreenGui.Parent = HiddenGui
			AddCleanup(function()
				ScreenGui:Destroy()
			end)

			const Parented = Formatters.CheckExist("compareinstances")(ScreenGui.Parent, HiddenGui)
			const InPlayerGui = ScreenGui:IsDescendantOf(Player.PlayerGui)

			ScreenGui:Destroy()

			assert(Parented, "couldn't parent a ScreenGui to it")
			assert(not InPlayerGui, "it's inside PlayerGui, where games can see it")
		end,
	},

	comparefunctions = {
		Test = function()
			const CompareFunctions = comparefunctions

			const function Test() end

			assert(CompareFunctions(Test, Test) == true, "a function should be equal to itself")
			assert(CompareFunctions(Test, print) == false, "two different functions shouldn't be equal")
		end,
	},

	getfunctionhash = {
		Test = function()
			const GetFunctionHash = getfunctionhash

			const function First()
				return 1
			end

			const function Second()
				return "debUNC"
			end

			const function SameAsFirst()
				return 1
			end

			const Hash = GetFunctionHash(First)

			Formatters.CheckReturnType(Hash, "string")

			assert(GetFunctionHash(First) == Hash, "hashing the same function twice gave different results")
			assert(GetFunctionHash(Second) ~= Hash, "two different functions gave the same hash")
			assert(GetFunctionHash(SameAsFirst) == Hash, "two functions with the same code gave different hashes, so it may not be hashing the function's code")
		end,
	},

	isexecutorclosure = {
		Test = function()
			const IsExecutorClosure = isexecutorclosure

			assert(IsExecutorClosure(function() end) == true, "should return true for a function made in the executor")
			assert(IsExecutorClosure(print) == false, "should return false for print")
			assert(
				IsExecutorClosure(require(GetPlayerModule().CommonUtils.CameraWrapper).getCamera) == false,
				"should return false for a function from the game's PlayerModule"
			)
		end,
	},

	islclosure = {
		Test = function()
			const IsLuaClosure = islclosure

			assert(IsLuaClosure(function() end) == true, "should return true for a Lua function")
			assert(IsLuaClosure(print) == false, "should return false for print")
			assert(IsLuaClosure(math.abs) == false, "should return false for math.abs")
		end,
	},

	isnewcclosure = {
		Test = function()
			const IsNewCClosure = isnewcclosure

			assert(IsNewCClosure(Formatters.CheckExist("newcclosure")(function() end)) == true, "should return true for a newcclosure")
			assert(IsNewCClosure(print) == false, "should return false for print")
			assert(IsNewCClosure(assert) == false, "should return false for assert")
			assert(IsNewCClosure(task.wait) == false, "should return false for task.wait")
			assert(IsNewCClosure(function() end) == false, "should return false for a Lua function")
		end,
	},

	getfflag = {
		Test = function()
			const Value = getfflag("MaxFrameBufferSize")

			Formatters.CheckReturnType(Value, "string")

			assert(Value ~= "", "the flag's value is empty")

			const Found, Missing = pcall(getfflag, `debUNC{math.random(1, 1e6)}`)

			assert(not Found or Missing == nil, "returned a value for a flag that doesn't exist")
		end,
	},

	setfflag = {
		Test = function()
			const GetFastFlag = Formatters.CheckExist("getfflag")
			const SetFastFlag = setfflag
			const Original = GetFastFlag("TaskSchedulerTargetFps")
			const NewValue = tostring(math.random(100, 200))

			AddCleanup(function()
				SetFastFlag("TaskSchedulerTargetFps", Original)
			end)

			SetFastFlag("TaskSchedulerTargetFps", NewValue)

			const Result = GetFastFlag("TaskSchedulerTargetFps")

			SetFastFlag("TaskSchedulerTargetFps", Original)

			Formatters.CheckEqual(Result, NewValue, "the flag")
		end,
	},

	["raknet.addsendhook"] = {
		Test = function()
			CheckPacketHook("send", false)
		end,
	},

	["raknet.removesendhook"] = {
		Test = function()
			CheckPacketHook("send", true)
		end,
	},

	["raknet.addreceivehook"] = {
		Test = function()
			CheckPacketHook("receive", false)
		end,
	},

	["raknet.removereceivehook"] = {
		Test = function()
			CheckPacketHook("receive", true)
		end,
	},

	["raknet.receive"] = {
		Test = function()
			const RakNet = raknet
			const Marker = `\255debUNC {math.random()}`

			local Received = false
			local HookFired = false

			const function OnReceive(Packet)
				HookFired = true

				if Packet.AsString ~= Marker then
					return
				end

				Received = true
				Packet:Block()
			end

			AddCleanup(function()
				RakNet.removereceivehook(OnReceive)
			end)

			RakNet.addreceivehook(OnReceive)
			RakNet.receive(Marker)

			WaitFor(function()
				return Received
			end, 3)

			RakNet.removereceivehook(OnReceive)

			if not HookFired then
				error({Skipped = "the receive hook never fired, so the packet can't be checked"})
			end

			assert(Received, "the receive hook didn't see the packet")
		end,
	},

	["raknet.send"] = {
		Test = function()
			const RakNet = raknet
			const Marker = `\255debUNC {math.random()}`

			RakNet.send(Marker)
			RakNet.send(buffer.fromstring(Marker))

			const Disconnected = RakNet.stats and WaitFor(function()
				return RakNet.stats().Connected == false
			end, 1)

			assert(not Disconnected, "got disconnected after sending a packet")
		end,
	},

	["debug.getcallstack"] = {
		Test = function()
			const GetCallStack = debug.getcallstack

			const function Inner()
				return GetCallStack()
			end

			const function Outer()
				const Stack = Inner()
				return Stack
			end

			const CallStack = Outer()

			Formatters.CheckReturnType(CallStack, "table")
			assert(CallStack[1].func == Inner and CallStack[2].func == Outer, "the running functions aren't in order")

			for _, Entry in CallStack do
				if Entry.func ~= Inner then
					continue
				end

				assert(typeof(Entry.currentline) == "number", "the stack entry for the calling function doesn't have a currentline number")
				return
			end

			error("couldn't find the calling function in the call stack")
		end,
	},

	["debug.isvalidlevel"] = {
		Test = function()
			const IsValidLevel = debug.isvalidlevel

			assert(IsValidLevel(1) == true, "level 1 should be valid")
			assert(IsValidLevel(500) == false, "level 500 shouldn't be valid")

			local Depth = 1

			while Formatters.CheckExist("debug.info")(Depth, "f") do
				Depth += 1
			end

			assert(IsValidLevel(Depth - 1) == true, `level {Depth - 1} exists and should be valid`)
			assert(IsValidLevel(Depth) == false, `level {Depth} is past the end of the stack and shouldn't be valid`)
		end,
	},

	["debug.setinfo"] = {
		Test = function()
			const function Test() end

			const Name = `debUNC{math.random(1, 1e6)}`

			debug.setinfo(Test, {name = Name})

			Formatters.CheckEqual(Formatters.CheckExist("debug.info")(Test, "n"), Name, "the function's name")
		end,
	},

	getallthreads = {
		Test = function()
			const Threads = getallthreads()

			assert(table.find(Threads, coroutine.running()), "didn't find the thread that's running this test")
			assert(#Threads > 1, "only found the thread that's running this test")
		end,
	},

	hasmetafield = {
		Test = function()
			const HasMetafield = hasmetafield

			assert(HasMetafield(setmetatable({}, {__index = {}}), "__index") == true, "should return true for a field the metatable has")
			assert(HasMetafield(setmetatable({}, {}), "__index") == false, "should return false for a field the metatable doesn't have")
			assert(HasMetafield(game, "__namecall") == true, "should see __namecall on game's locked metatable")
		end,
	},

	makereadonly = {
		Test = function()
			const Table = {}

			makereadonly(Table)

			assert(table.isfrozen(Table), "the table wasn't made read-only")
			assert(not pcall(function()
				Table.debUNC = true
			end), "could still write to the table after making it read-only")
		end,
	},

	iswriteable = {
		Test = function()
			const IsWriteable = iswriteable

			assert(IsWriteable({}) == true, "should return true for a normal table")
			assert(IsWriteable(table.freeze({})) == false, "should return false for a frozen table")
		end,
	},

	isreadonly = {
		Test = function()
			const IsReadOnly = isreadonly

			assert(IsReadOnly({}) == false, "should return false for a normal table")
			assert(IsReadOnly(table.freeze({})) == true, "should return true for a frozen table")
		end,
	},

	["crypt.hmac"] = {
		Test = function()
			const Hmac = crypt.hmac
			const GeneratedString = CreateRandomString(math.random(1, 64))

			Formatters.CheckEqual(
				Hmac("key", "The quick brown fox jumps over the lazy dog", "sha256"),
				"97yD9DBThCSxMpjmqm+xQ+9NWaFJRhdZl0edvC0aPNg=",
				"the known sha256 hmac"
			)
			Formatters.CheckEqual(
				Hmac("Jefe", "what do ya want for nothing?", "sha256"),
				"W9zBRr9gdU5qBCQmCJV1x1oAPwidJzmDnexYuWTsOEM=",
				"the second known sha256 hmac"
			)
			assert(Hmac("key", GeneratedString, "sha256") == Hmac("key", GeneratedString, "sha256"), "the same key and data gave different results")
			assert(Hmac("key", GeneratedString, "sha256") ~= Hmac("other key", GeneratedString, "sha256"), "two different keys gave the same result")
		end,
	},

	["crypt.random"] = {
		Test = function()
			const Random = crypt.random
			const Length = math.random(8, 64)
			const Bytes = Random(Length)

			Formatters.CheckEqual(#Bytes, Length, "the length of the random bytes")
			assert(Random(Length) ~= Bytes, "generated the same bytes twice")

			const Seen = {}

			for Byte in Random(64):gmatch(".") do
				Seen[Byte] = true
			end

			local Different = 0

			for _ in Seen do
				Different += 1
			end

			assert(Different > 8, `64 random bytes only had {Different} different values`)
		end,
	},

	["crypt.decrypt"] = {
		Test = function()
			const Crypt = crypt
			const Encrypt = Formatters.CheckExist("crypt.encrypt")
			const Key = Crypt.generatekey()

			for _ = 1, 50 do
				const Text = CreateRandomString(math.random(1, 64))
				const Encrypted, InitializationVector = Encrypt(Text, Key)
				const Decrypted = Crypt.decrypt(Encrypted, Key, InitializationVector)

				assert(Decrypted == Text, `decrypting {#Text} bytes of random text gave back {#Decrypted} bytes that don't match`)
			end

			const Text = CreateRandomString(math.random(1, 64))
			const Encrypted, InitializationVector = Encrypt(Text, Key)

			CheckWrongKey(Crypt, Encrypted, InitializationVector, Text)
		end,
	},

	getmodules = {
		Test = function()
			const Modules = getmodules()

			Formatters.CheckReturnType(Modules, "table")

			assert(table.find(Modules, GetPlayerModule()), "didn't find PlayerModule, which is always loaded")

			const NewModule = Instance.new("ModuleScript")

			NewModule.Parent = workspace
			AddCleanup(function()
				NewModule:Destroy()
			end)

			const FoundNew = table.find(getmodules(), NewModule)

			NewModule:Destroy()

			assert(FoundNew, "didn't find a new ModuleScript")

			for _, Module in Modules do
				assert(Module:IsA("ModuleScript"), `'{Module}' isn't a ModuleScript`)
			end
		end,
	},

	getrendersteppedlist = {
		Test = function()
			const RunService = game:GetService("RunService")
			const Name = `debUNC{math.random(1, 1e6)}`

			const function OnRenderStep() end

			AddCleanup(function()
				RunService:UnbindFromRenderStep(Name)
			end)

			RunService:BindToRenderStep(Name, 123, OnRenderStep)

			const List = getrendersteppedlist()

			RunService:UnbindFromRenderStep(Name)

			for _, Entry in List do
				if Entry.Name ~= Name then
					continue
				end

				assert(Entry.Function == OnRenderStep, ".Function isn't the function that was bound")
				Formatters.CheckEqual(Entry.Priority, 123, "the binding's priority")
				return
			end

			error("didn't find a newly bound RenderStep function")
		end,
	},

	cansignalreplicate = {
		Test = function()
			const CanSignalReplicate = cansignalreplicate

			assert(CanSignalReplicate(Player.Kill) == true, "should return true for Player.Kill")
			assert(CanSignalReplicate(workspace.ChildAdded) == false, "should return false for workspace.ChildAdded")
			assert(CanSignalReplicate(Instance.new("Part").Touched) == false, "should return false for a part's Touched")
		end,
	},

	getactorfromthread = {
		Test = function()
			assert(
				RunOnNewActor("Actor:SetAttribute('Matched', getactorfromthread(coroutine.running()) == Actor)").Matched == true,
				"didn't return the actor that the thread is running on"
			)
			assert(getactorfromthread(coroutine.running()) == nil, "should return nil for a thread that isn't on an actor")
		end,
	},

	hooksignal = {
		Test = function()
			const NumberValue = Instance.new("NumberValue")

			local FiredCount = 0
			local HookArgument

			NumberValue.Changed:Connect(function()
				FiredCount += 1
			end)

			hooksignal(NumberValue.Changed, function(Info)
				HookArgument = Info
				return false
			end)

			NumberValue.Value = 1
			task.wait()

			assert(HookArgument ~= nil, "the hook wasn't called when the signal fired")
			assert(FiredCount == 0, "returning false from the hook didn't stop the connection from firing")

			const AllowedValue = Instance.new("NumberValue")

			local AllowedCount = 0

			AllowedValue.Changed:Connect(function()
				AllowedCount += 1
			end)

			hooksignal(AllowedValue.Changed, function()
				return true
			end)

			AllowedValue.Value = 1
			task.wait()

			assert(AllowedCount == 1, "returning true from the hook stopped the connection from firing")
		end,
	},

	issignalhooked = {
		Test = function()
			const IsSignalHooked = issignalhooked
			const NumberValue = Instance.new("NumberValue")

			NumberValue.Changed:Connect(function() end)

			assert(IsSignalHooked(NumberValue.Changed) == false, "should return false before the signal is hooked")

			Formatters.CheckExist("hooksignal")(NumberValue.Changed, function() end)

			assert(IsSignalHooked(NumberValue.Changed) == true, "should return true after the signal is hooked")
		end,
	},

	restoresignal = {
		Test = function()
			const NumberValue = Instance.new("NumberValue")

			local FiredCount = 0
			local HookCount = 0

			NumberValue.Changed:Connect(function()
				FiredCount += 1
			end)

			Formatters.CheckExist("hooksignal")(NumberValue.Changed, function()
				HookCount += 1
			end)

			NumberValue.Value = 1
			task.wait()

			assert(HookCount == 1, "hooksignal didn't hook the signal, can't continue the test")

			restoresignal(NumberValue.Changed)

			const FiredBefore = FiredCount

			NumberValue.Value = 2
			task.wait()

			assert(HookCount == 1, "the hook was still called after restoresignal")
			assert(FiredCount == FiredBefore + 1, "the connection didn't fire after restoresignal")
		end,
	},

	["oth.hook"] = {
		Test = CheckOffThreadHook,
	},

	["oth.unhook"] = {
		Test = CheckOffThreadHook,
	},

	["oth.is_hook_thread"] = {
		Test = CheckOffThreadHook,
	},

	["oth.get_root_callback"] = {
		Test = CheckOffThreadHook,
	},

	["oth.get_original_thread"] = {
		Test = CheckOffThreadHook,
	},

	keyclick = {
		Test = function()
			CheckInputFree()

			const Detected = WaitForInput(UserInputService.InputBegan, function(Input)
				return Input.KeyCode == Enum.KeyCode.J
			end, function()
				keyclick(0x4A)
			end)

			const Released = WaitFor(function()
				return not UserInputService:IsKeyDown(Enum.KeyCode.J)
			end, 1)

			if not Released then
				Formatters.CheckExist("keyrelease")(0x4A)
			end

			assert(Detected, "the key press wasn't detected")
			assert(Released, "the key was left held down, keyclick should press and release it")
		end,
		RunLast = true,
	},

	loadfileasync = {
		Test = function()
			const FileName = `File_{math.random()}.lua`
			const Value = math.random()

			Formatters.CheckExist("writefile")(FileName, `return {Value}`)

			const Loaded = CallAsync(loadfileasync, FileName)

			RemovePath("delfile", FileName)

			Formatters.CheckReturnType(Loaded, "function")
			Formatters.CheckEqual(Loaded(), Value, "the value the loaded file returned")
		end,
	},

	appendfileasync = {
		Test = function()
			const ReadFile = Formatters.CheckExist("readfile")
			const FileName = `File_{math.random()}.txt`
			const Appended = tostring(math.random())

			Formatters.CheckExist("writefile")(FileName, "debUNC")

			CallAsync(appendfileasync, FileName, Appended)

			const Found = WaitFor(function()
				return ReadFile(FileName) == `debUNC{Appended}`
			end, 2)

			RemovePath("delfile", FileName)

			assert(Found, "the text wasn't added to the end of the file within 2 seconds")
		end,
	},

	saveinstance = {
		Test = function()
			const PredictedMegabytes = #game:GetDescendants() * 10 / 1e6

			if PredictedMegabytes > 10 then
				error({Skipped = `the saved place would be about {math.floor(PredictedMegabytes)} MB, which is too large to test quickly`, Environment = true})
			end

			const FileName = saveinstance({noscripts = true})

			Formatters.CheckReturnType(FileName, "string")

			const Exists = Formatters.CheckExist("isfile")(FileName)
			const Size = Exists and #Formatters.CheckExist("readfile")(FileName)

			RemovePath("delfile", FileName)

			assert(Exists, `the saved file '{FileName}' doesn't exist`)
			assert(Size > 1000, `the saved file is only {Size} bytes, so it can't have the place in it`)
		end,
		RunLast = true,
	},

	getcustomasset = {
		Test = function()
			const FileName = `File_{math.random()}.png`

			Formatters.CheckExist("writefile")(FileName, TestImage)

			const Success, AssetId = pcall(getcustomasset, FileName)

			if not Success then
				RemovePath("delfile", FileName)
				error(`errored while getting the asset with {AssetId}`)
			end

			const FetchStatus = GetAssetStatus(AssetId)

			RemovePath("delfile", FileName)

			Formatters.CheckReturnType(AssetId, "string")

			assert(AssetId:find("^rbxasset://"), `expected an rbxasset:// id, got '{AssetId}'`)
			Formatters.CheckEqual(FetchStatus, Enum.AssetFetchStatus.Success, "the status of loading the asset")

			const GarbageName = `File_{math.random()}.png`

			Formatters.CheckExist("writefile")(GarbageName, "debUNC")

			const BadStatus = GetAssetStatus(getcustomasset(GarbageName))

			RemovePath("delfile", GarbageName)

			assert(BadStatus ~= Enum.AssetFetchStatus.Success, "a file that isn't an image loaded as one, so the file probably wasn't used")
		end,
	},

	getsignalarguments = {
		Test = function()
			const Arguments = getsignalarguments(Instance.new("Part").Touched)

			Formatters.CheckReturnType(Arguments, "table")
			Formatters.CheckEqual(#Arguments, 1, "the number of arguments Touched has")
			assert(Arguments[1] == "Instance" or Arguments[1] == "BasePart", `expected the type of Touched's argument to be Instance or BasePart, got {Arguments[1]}`)
			Formatters.CheckEqual(#getsignalarguments(UserInputService.InputBegan), 2, "the number of arguments InputBegan has")
		end,
	},

	getsignalargumentsinfo = {
		Test = function()
			const Info = getsignalargumentsinfo(Instance.new("Part").Touched)

			Formatters.CheckReturnType(Info, "table")

			assert(typeof(Info[1]) == "table", `expected a table for each argument, got {typeof(Info[1])}`)
			Formatters.CheckEqual(Info[1].Name, "otherPart", "the name of Touched's argument")
			assert(Info[1].Type == "Instance" or Info[1].Type == "BasePart", `expected the type of Touched's argument to be Instance or BasePart, got {Info[1].Type}`)

			const InputInfo = getsignalargumentsinfo(UserInputService.InputBegan)

			Formatters.CheckEqual(#InputInfo, 2, "the number of arguments InputBegan has")
			Formatters.CheckEqual(InputInfo[2].Name, "gameProcessedEvent", "the name of InputBegan's second argument")
		end,
	},

	getsignalwhitelist = {
		Test = function()
			const Whitelist = getsignalwhitelist()

			Formatters.CheckReturnType(Whitelist, "table")

			assert(#Whitelist > 1, "the whitelist should have more than one signal")

			for _, Entry in Whitelist do
				assert(
					typeof(Entry) == "table" and typeof(Entry.Event) == "string" and typeof(Entry.Parent) == "string",
					"each entry should be a table with an Event and a Parent string"
				)
			end
		end,
	},

	createcommchannel = {
		Test = CheckCommChannel,
	},

	getcommchannel = {
		Test = CheckCommChannel,
	},

	["Drawing.Fonts"] = {
		Test = function()
			const Fonts = Drawing.Fonts

			for Name, Value in {
				UI = 0,
				System = 1,
				Plex = 2,
				Monospace = 3,
			} do
				Formatters.CheckEqual(Fonts[Name], Value, `Drawing.Fonts.{Name}`)
			end
		end,
		ValueType = "table",
	},

	["Signal.new"] = {
		Test = function()
			const CreatedSignal = Signal.new()
			const Value = math.random()

			local Received
			local OnceCount = 0

			const Connection = CreatedSignal:Connect(function(...)
				Received = table.pack(...)
			end)

			CreatedSignal:Once(function()
				OnceCount += 1
			end)

			CreatedSignal:Fire(Value, "debUNC")
			Connection:Disconnect()

			const ReceivedAfterFire = Received

			Received = nil
			CreatedSignal:Fire(Value)

			task.delay(0.1, function()
				CreatedSignal:Fire(Value)
			end)

			assert(ReceivedAfterFire and ReceivedAfterFire[1] == Value and ReceivedAfterFire[2] == "debUNC", "the connection didn't get the values it was fired with")
			assert(Received == nil, "the connection still fired after :Disconnect()")
			Formatters.CheckEqual(OnceCount, 1, "the number of times a :Once connection fired")
			Formatters.CheckEqual(CreatedSignal:Wait(), Value, "the value :Wait() returned")
		end,
	},

	setnamecallmethod = {
		Test = function()
			const ProxyTest = newproxy(true)
			const NewMethod = `debUNC{math.random(1, 1e6)}`

			local Detected

			local FullName

			getmetatable(ProxyTest).__namecall = function()
				setnamecallmethod(NewMethod)
				Detected = Formatters.CheckExist("getnamecallmethod")()
				setnamecallmethod("GetFullName")
				FullName = Formatters.CheckExist("getrawmetatable")(game).__namecall(game)
			end

			ProxyTest:Original()

			Formatters.CheckEqual(Detected, NewMethod, "the namecall method after setting it")
			Formatters.CheckEqual(FullName, game:GetFullName(), "the result of calling game's __namecall after setting the method")
		end,
	},

	newlclosure = {
		Test = function()
			const NewLClosure = newlclosure
			const Wrapped = NewLClosure(math.abs)

			assert(Wrapped ~= math.abs, "the returned function is the same as the function given")
			assert(Formatters.CheckExist("islclosure")(Wrapped), "the returned function isn't a Lua closure")
			Formatters.CheckEqual(Wrapped(-5), 5, "the wrapped math.abs(-5)")
		end,
	},

	getproperties = {
		Test = function()
			const Part = Instance.new("Part")
			const Size = Vector3.new(math.random(1, 9), math.random(1, 9), math.random(1, 9))

			Part.Size = Size

			const Properties = getproperties(Part)

			Formatters.CheckReturnType(Properties, "table")
			Formatters.CheckEqual(Properties.Size, Size, "the Size in the returned table")
			Formatters.CheckEqual(Properties.Name, "Part", "the Name in the returned table")
			Formatters.CheckEqual(getproperties(Instance.new("Fire")).Heat, 9, "a Fire's Heat in the returned table")
		end,
	},

	gethiddenproperties = {
		Test = function()
			const Part = Instance.new("Part")
			const Properties = gethiddenproperties(Part)

			Formatters.CheckReturnType(Properties, "table")

			assert(next(Properties) ~= nil, "the table of hidden properties is empty")
			assert(Properties.Size == nil, "Size isn't hidden, so it shouldn't be in the table")

			local FoundHidden = false

			for Name in Properties do
				if pcall(function()
					return (Part :: any)[Name]
				end) then
					continue
				end

				FoundHidden = true
				break
			end

			assert(FoundHidden, "none of the returned properties are actually hidden")

			const Fire = Instance.new("Fire")
			const Size = math.random(6, 20)

			Fire.Size = Size

			Formatters.CheckEqual(gethiddenproperties(Fire).size_xml, Size, "size_xml")
		end,
	},

	hasmetatable = {
		Test = function()
			const HasMetatable = hasmetatable

			assert(HasMetatable(setmetatable({}, {})) == true, "should return true for a table with a metatable")
			assert(HasMetatable({}) == false, "should return false for a table without a metatable")
			assert(HasMetatable(game) == true, "should return true for game, which has a locked metatable")
		end,
	},

	getmetafield = {
		Test = function()
			const GetMetafield = getmetafield
			const Value = math.random()

			Formatters.CheckEqual(GetMetafield(setmetatable({}, {__index = Value}), "__index"), Value, "the __index field")
			Formatters.CheckReturnType(GetMetafield(game, "__namecall"), "function")
		end,
	},

	iscorescript = {
		Test = function()
			const IsCoreScript = iscorescript

			const CoreScript = game:GetService("CoreGui"):FindFirstChildWhichIsA("ModuleScript", true)

			assert(IsCoreScript(GetPlayerModule()) == false, "should return false for PlayerModule, which isn't a core script")

			if not CoreScript then
				error({Skipped = "no core script was found to check", Environment = true})
			end

			assert(IsCoreScript(CoreScript) == true, `should return true for '{CoreScript:GetFullName()}', which is a core script`)
		end,
	},

	getscriptthread = {
		Test = CheckScriptThread,
	},

	getscriptfromthread = {
		Test = CheckScriptThread,
	},

	readfileasync = {
		Test = function()
			const FileName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			Formatters.CheckExist("writefile")(FileName, Text)

			const Result = CallAsync(readfileasync, FileName)

			RemovePath("delfile", FileName)

			Formatters.CheckEqual(Result, Text, "the text read from the file")
		end,
	},

	writefileasync = {
		Test = function()
			const ReadFile = Formatters.CheckExist("readfile")
			const FileName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			CallAsync(writefileasync, FileName, Text)

			const Written = WaitFor(function()
				return pcall(ReadFile, FileName) and ReadFile(FileName) == Text
			end, 2)

			RemovePath("delfile", FileName)

			assert(Written, "the text wasn't written to the file within 2 seconds")
		end,
	},

	writecustomasset = {
		Test = function()
			const FileName = `File_{math.random()}.png`

			const AssetId = writecustomasset(FileName, TestImage)

			const Exists = Formatters.CheckExist("isfile")(FileName)
			const FetchStatus = GetAssetStatus(AssetId)

			RemovePath("delfile", FileName)

			assert(Exists, "the file wasn't written")
			assert(typeof(AssetId) == "string" and AssetId:find("^rbxasset://"), `expected an rbxasset:// id, got '{AssetId}'`)
			Formatters.CheckEqual(FetchStatus, Enum.AssetFetchStatus.Success, "the status of loading the asset")
		end,
	},

	dofile = {
		Test = function()
			const WriteFile = Formatters.CheckExist("writefile")
			const DoFile = dofile
			const FileName = `File_{math.random()}.lua`
			const Value = math.random()
			const Marker = `debUNC{math.random(1, 1e6)}`

			WriteFile(FileName, `return {Value}`)

			const Success, Result = pcall(DoFile, FileName)

			WriteFile(FileName, `error("{Marker}")`)

			const Ran, ErrorMessage = pcall(DoFile, FileName)

			RemovePath("delfile", FileName)

			assert(Success, `errored while running the file with {Result}`)
			Formatters.CheckEqual(Result, Value, "the value the file returned")
			assert(not Ran, "an error inside of the file didn't reach the caller")
			assert(tostring(ErrorMessage):find(Marker, 1, true), `the file's error message was lost, got '{ErrorMessage}'`)
		end,
	},

	getobjects = {
		Test = function()
			const Objects = getobjects("rbxassetid://125013769")

			Formatters.CheckReturnType(Objects, "table")

			const Sword = Objects[1]

			assert(typeof(Sword) == "Instance", `expected an instance, got {typeof(Sword)}`)

			const ClassName, Name, Parent, HasHandle = Sword.ClassName, Sword.Name, Sword.Parent, Sword:FindFirstChild("Handle") ~= nil

			Sword:Destroy()

			Formatters.CheckEqual(ClassName, "Tool", "the loaded model's class")
			Formatters.CheckEqual(Name, "LinkedSword", "the loaded model's name")
			assert(Parent == nil, "the loaded model shouldn't be parented to anything")
			assert(HasHandle, "the loaded model doesn't have the sword's Handle")
		end,
	},

	hookproto = {
		Test = CheckProtoHook,
	},

	isprotohooked = {
		Test = CheckProtoHook,
	},

	restoreproto = {
		Test = CheckProtoHook,
	},

	getcallbackvalue = {
		Test = function()
			const GetCallbackValue = getcallbackvalue
			const BindableFunction = Instance.new("BindableFunction")

			const function OnInvoke()
				return "debUNC"
			end

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == nil, "should return nil when no callback is set")

			BindableFunction.OnInvoke = OnInvoke

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == OnInvoke, "didn't return the callback that was set")
		end,
	},

	getfunctionbytecode = {
		Test = function()
			const GetFunctionBytecode = getfunctionbytecode

			const function First()
				return 1
			end

			const function Second()
				return "debUNC"
			end

			const Bytecode = GetFunctionBytecode(First)

			Formatters.CheckReturnType(Bytecode, "string")

			assert(#Bytecode > 0, "the bytecode is empty")
			assert(GetFunctionBytecode(Second) ~= Bytecode, "two different functions gave the same bytecode")
		end,
	},

	getobjectreferences = {
		Test = function()
			const Box = {Holder = {{}}}
			const References = getobjectreferences(Box.Holder[1])

			assert(table.find(References, Box.Holder), "didn't find the table holding the object")
		end,
	},

	getfunctionreferences = {
		Test = function()
			const Box = {Holder = {function() end}}

			assert(table.find(getfunctionreferences(Box.Holder[1]), Box.Holder), "didn't find the table holding the function")
		end,
	},

	trampolinecall = {
		OtherNames = {"trampoline_call", "syn.trampoline_call"},
		Test = function()
			const TrampolineCall = FindFirstFunction("trampolinecall") or FindFirstFunction("trampoline_call") or FindFirstFunction("syn.trampoline_call")
			const GetIdentity = getthreadidentity
			const GetScriptThread = getscriptthread
			const CheckCaller = checkcaller
			const GetCallingScript = getcallingscript
			const GetInfo = Formatters.CheckExist("debug.info")
			const Line = math.random(100, 999)
			const Value = math.random()

			const function FakeCaller() end

			const StackSuccess, Name, CurrentLine = TrampolineCall(function()
				return GetInfo(2, "nl")
			end, {
				{
					func = FakeCaller,
					currentline = Line,
				},
			}, {})

			assert(typeof(StackSuccess) == "boolean", `the first value it returns should be whether the call worked, got {typeof(StackSuccess)} instead, so it probably just called the function`)
			assert(StackSuccess == true, "should return true when the function doesn't error")
			Formatters.CheckEqual(Name, "FakeCaller", "the name of the fake caller")
			Formatters.CheckEqual(CurrentLine, Line, "the line of the fake caller")

			const ArgumentSuccess, Result = TrampolineCall(function(Argument)
				return Argument
			end, {}, {}, Value)

			assert(ArgumentSuccess == true and Result == Value, "the arguments or return values didn't get passed through")

			const ErrorSuccess, ErrorMessage = TrampolineCall(function()
				error("debUNC", 0)
			end, {}, {})

			assert(ErrorSuccess == false, "should return false when the function errors")
			Formatters.CheckEqual(ErrorMessage, "debUNC", "the error message")

			const EnvironmentSuccess, EnvironmentValue = TrampolineCall(function()
				return debUNC
			end, {}, {
				env = {debUNC = Value},
			})

			assert(EnvironmentSuccess == true, `the env option errored with {EnvironmentValue}`)
			Formatters.CheckEqual(EnvironmentValue, Value, "the value in the given environment")

			if GetIdentity then
				const Identity = GetIdentity()
				const IdentitySuccess, NewIdentity = TrampolineCall(GetIdentity, {}, {identity = 2})

				assert(IdentitySuccess == true, `the identity option errored with {NewIdentity}`)
				Formatters.CheckEqual(NewIdentity, 2, "the identity inside of the call")
				Formatters.CheckEqual(GetIdentity(), Identity, "the identity after the call")
			end

			if not GetScriptThread or not CheckCaller or not GetCallingScript or not Player.Character then
				return
			end

			const Animate = Player.Character:FindFirstChild("Animate")
			const Thread = Animate and GetScriptThread(Animate)

			if not Thread then
				return
			end

			const ThreadSuccess, IsExecutor, CallingScript = TrampolineCall(function()
				return CheckCaller(), GetCallingScript()
			end, {}, {thread = Thread})

			assert(ThreadSuccess == true, `the thread option errored with {IsExecutor}`)
			assert(IsExecutor == false, "checkcaller should return false on a game script's thread")
			Formatters.CheckEqual(CallingScript, Animate, "the calling script on the game script's thread")
		end,
	},

	getclipboard = {
		Test = CheckClipboard,
		RunLast = true,
	},

	setclipboard = {
		Test = CheckClipboard,
		RunLast = true,
	},

	getfilesize = {
		Test = function()
			const FileName = `File_{math.random()}.txt`
			const Text = string.rep("debUNC", math.random(1, 100))

			Formatters.CheckExist("writefile")(FileName, Text)

			const Size = getfilesize(FileName)

			RemovePath("delfile", FileName)

			Formatters.CheckEqual(Size, #Text, "the size of the file")
		end,
	},

	renamefile = {
		Test = function()
			const IsFile = Formatters.CheckExist("isfile")
			const OldName = `File_{math.random()}.txt`
			const NewName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			Formatters.CheckExist("writefile")(OldName, Text)

			renamefile(OldName, NewName)

			const OldExists = IsFile(OldName)
			const Result = Formatters.CheckExist("readfile")(NewName)

			RemovePath("delfile", NewName)

			assert(not OldExists, "the old file still exists")
			Formatters.CheckEqual(Result, Text, "the renamed file's text")
		end,
	},

	movefile = {
		Test = function()
			const FolderName = `Folder_{math.random()}`
			const FileName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			Formatters.CheckExist("makefolder")(FolderName)
			Formatters.CheckExist("writefile")(FileName, Text)

			movefile(FileName, `{FolderName}/{FileName}`)

			const OldExists = Formatters.CheckExist("isfile")(FileName)
			const Result = Formatters.CheckExist("readfile")(`{FolderName}/{FileName}`)

			RemovePath("delfolder", FolderName)

			assert(not OldExists, "the old file still exists")
			Formatters.CheckEqual(Result, Text, "the moved file's text")
		end,
	},
}

const EconomyUrl = "https://economy.roblox.com/v1/user/currency"

const function CheckLoginHidden(Get: () -> string)
	const Success, Body = pcall(Get)

	if not Success or typeof(Body) ~= "string" then
		return
	end

	assert(
		not Body:find('"robux"', 1, true) and not Body:find('"isPremium"', 1, true),
		"your login was sent along, so any script could read your account through it"
	)
end

const function CheckReached(Success: boolean, Result: any): boolean
	if Success then
		return Result ~= nil and Result ~= ""
	end

	const Message = tostring(Result)

	return Message:find("Argument %d+ missing") ~= nil or Message:find("Unable to cast") ~= nil or Message:find("invalid argument") ~= nil
end

const function CheckMethodsBlocked(Methods: {{any}}, Reason: string)
	const Unblocked = {}

	for _, Method in Methods do
		const ServiceName, MethodName, Argument = Method[1], Method[2], Method[3]
		const Found, Service = pcall(game.GetService, game, ServiceName)

		if not Found then
			continue
		end

		const Reached = CheckReached(pcall(function()
			return Service[MethodName](Service, Argument)
		end)) or CheckReached(pcall(loadstring(`local Service, Argument = ... return Service:{MethodName}(Argument)`) :: Function, Service, Argument))

		if Reached then
			table.insert(Unblocked, `{ServiceName}:{MethodName}`)
		end
	end

	assert(#Unblocked == 0, `{table.concat(Unblocked, ", ")} can be called, which lets scripts {Reason}`)
end

const SecurityTests: {[string]: any} = {
	["security: purchases need your approval"] = {
		Test = function()
			CheckMethodsBlocked({
				{"MarketplaceService", "PerformPurchase"},
				{"MarketplaceService", "PerformPurchaseV2"},
				{"MarketplaceService", "PerformBulkPurchase"},
				{"MarketplaceService", "PerformSubscriptionPurchase"},
				{"MarketplaceService", "PerformSubscriptionPurchaseV2"},
				{"MarketplaceService", "PerformCancelSubscription"},
				{"MarketplaceService", "PrepareCollectiblesPurchase"},
				{"MarketplaceService", "PromptPurchase"},
				{"MarketplaceService", "PromptProductPurchase"},
				{"MarketplaceService", "PromptGamePassPurchase"},
				{"MarketplaceService", "PromptBundlePurchase"},
				{"MarketplaceService", "PromptBulkPurchase"},
				{"MarketplaceService", "PromptPremiumPurchase"},
				{"MarketplaceService", "PromptSubscriptionPurchase"},
				{"MarketplaceService", "PromptCancelSubscription"},
				{"MarketplaceService", "PromptRobloxSubscriptionPurchase"},
				{"MarketplaceService", "PromptVIPServerPurchase"},
				{"MarketplaceService", "PromptCollectiblesPurchase"},
				{"MarketplaceService", "PromptNativePurchase"},
				{"MarketplaceService", "PromptNativePurchaseWithContext"},
				{"MarketplaceService", "PromptNativePurchaseWithLocalPlayer"},
				{"MarketplaceService", "PromptNativePurchaseWithLocalPlayerWithPaymentSessionId"},
				{"MarketplaceService", "PromptNativePurchaseWithPaymentSessionId"},
				{"MarketplaceService", "PromptRobloxPurchase"},
				{"MarketplaceService", "PromptThirdPartyPurchase"},
			}, "spend your Robux without asking")
		end,
	},

	["security: requests can't use your login"] = {
		Test = function()
			const Request = request

			if Request then
				CheckLoginHidden(function()
					return Request({
						Url = EconomyUrl,
						Method = "GET",
					}).Body
				end)
			end

			CheckLoginHidden(function()
				return game:HttpGet(EconomyUrl)
			end)

			CheckMethodsBlocked({
				{"HttpRbxApiService", "GetAsyncFullUrl", EconomyUrl},
				{"HttpRbxApiService", "GetAsync"},
				{"HttpRbxApiService", "PostAsync"},
				{"HttpRbxApiService", "PostAsyncFullUrl"},
				{"HttpRbxApiService", "RequestAsync"},
				{"HttpService", "RequestInternal"},
				{"HttpService", "requestInternal"},
				{"OpenCloudService", "HttpRequestAsync"},
				{"ContentProvider", "SetBaseUrl"},
				{"OpenCloudService", "InvokeAsync"},
				{"OpenCloudService", "GetApiV1"},
			}, "send web requests logged in as you")
		end,
	},

	["security: account data and tokens stay private"] = {
		Test = function()
			CheckMethodsBlocked({
				{"MarketplaceService", "GetRobuxBalance"},
				{"AccountService", "GetCredentialsHeaders"},
				{"AccountService", "GetDeviceAccessToken"},
				{"AccountService", "GetDeviceIntegrityToken"},
				{"AccountService", "GetDeviceIntegrityTokenYield"},
				{"MarketplaceService", "GetUserSubscriptionPaymentHistoryAsync"},
				{"MarketplaceService", "GetUserSubscriptionDetailsInternalAsync"},
				{"CaptureService", "RetrieveCaptures"},
				{"CaptureService", "GetCaptureUploadDataAsync"},
			}, "reach your private account data")
		end,
	},

	["security: scripts can't run things outside Roblox"] = {
		Test = function()
			CheckMethodsBlocked({
				{"LinkingService", "OpenUrl"},
				{"MessageBusService", "Call"},
				{"MessageBusService", "Publish"},
				{"MessageBusService", "MakeRequest"},
				{"BrowserService", "OpenBrowserWindow"},
				{"BrowserService", "ExecuteJavaScript"},
				{"GuiService", "OpenBrowserWindow"},
				{"ScriptContext", "AddCoreScriptLocal"},
				{"MessageBusService", "PublishProtocolMethodRequest"},
				{"MessageBusService", "PublishProtocolMethodResponse"},
				{"MessageBusService", "Subscribe"},
				{"MessageBusService", "GetLast"},
				{"BrowserService", "OpenNativeOverlay"},
				{"GuiService", "OpenNativeOverlay"},
			}, "open links or run things outside of Roblox")
		end,
	},

	["security: your account can't be changed without asking"] = {
		Test = function()
			CheckMethodsBlocked({
				{"AvatarEditorService", "NoPromptApplyProfileConfiguration"},
				{"AvatarEditorService", "NoPromptCreateOutfit"},
				{"AvatarEditorService", "NoPromptDeleteOutfit"},
				{"AvatarEditorService", "NoPromptRenameOutfit"},
				{"AvatarEditorService", "NoPromptSaveAvatar"},
				{"AvatarEditorService", "NoPromptSaveAvatarThumbnailCustomization"},
				{"AvatarEditorService", "NoPromptSetFavorite"},
				{"AvatarEditorService", "NoPromptUpdateOutfit"},
				{"AvatarEditorService", "PerformCreateOutfitWithDescription"},
				{"AvatarEditorService", "PerformRenameOutfit"},
				{"AvatarEditorService", "PerformSaveAvatarWithDescription"},
				{"AvatarEditorService", "PerformUpdateOutfit"},
				{"CaptureService", "CreatePostAsync"},
				{"Players", "ReportAbuse"},
				{"Players", "ReportAbuseV3"},
				{"AvatarEditorService", "SetAllowInventoryReadAccess"},
				{"AvatarEditorService", "PerformDeleteOutfit"},
				{"AvatarEditorService", "PerformSetFavorite"},
				{"CaptureService", "DeleteCapture"},
				{"CaptureService", "DeleteCapturesAsync"},
			}, "change your account without asking")
		end,
	},

	["security: file:// is blocked"] = {
		Test = function()
			const Request = request

			if Request then
				const Success, Response = pcall(Request, {
					Url = "file:///C:/",
					Method = "GET",
				})

				assert(not Success or not Response or not Response.Success or Response.Body == "", "request can read files on your computer through file://")
			end

			const Success, Result = pcall(game.HttpGet, game, "file:///C:/")

			assert(not Success or Result == nil or Result == "", "game:HttpGet can read files on your computer through file://")

			for Name, Read in {
				["game:HttpGetAsync"] = function()
					return game:HttpGetAsync("file:///C:/")
				end,
				["game:HttpPost"] = function()
					return game:HttpPost("file:///C:/", "")
				end,
			} do
				const ReadSuccess, ReadResult = pcall(Read)

				assert(not ReadSuccess or ReadResult == nil or ReadResult == "", `{Name} can read files on your computer through file://`)
			end

			CheckMethodsBlocked({
				{"InsertService", "GetLocalFileContents", "rbxasset://fonts/families/SourceSansPro.json"},
			}, "read files on your computer")
		end,
	},

	["security: bytecode can't be loaded"] = {
		Test = function()
			const Bytecode = Formatters.CheckExist("getscriptbytecode")(GetPlayerScripts():FindFirstChildWhichIsA("LocalScript", true))

			assert(typeof(Bytecode) == "string" and #Bytecode > 0, "couldn't get any bytecode to test with")
			assert(loadstring(Bytecode) == nil, "loadstring ran raw bytecode, which lets scripts break out of the sandbox")
		end,
	},

	["security: blocks can't be bypassed"] = {
		Test = function()
			const Bypasses = {}

			for Name, GetRoot in {
				["stats().Parent"] = function()
					return stats().Parent
				end,
				["settings().Parent"] = function()
					return settings().Parent
				end,
				["UserSettings().Parent"] = function()
					return UserSettings().Parent
				end,
				["Stats service's Parent"] = function()
					return game:GetService("Stats").Parent
				end,
				["UserGameSettings service's Parent"] = function()
					return game:GetService("UserGameSettings").Parent
				end,
			} do
				const Success, Root = pcall(GetRoot)

				if not Success or typeof(Root) ~= "Instance" then
					continue
				end

				const Reached, Balance = pcall(function()
					return Root:GetService("MarketplaceService"):GetRobuxBalance()
				end)

				if Reached and Balance ~= nil then
					table.insert(Bypasses, Name)
				end
			end

			assert(#Bypasses == 0, `{table.concat(Bypasses, ", ")} reached a method that's blocked everywhere else`)
		end,
	},
}

for Name, Info in SecurityTests do
	Info.Security = true
	Tests[Name] = Info
end

const NoTests: {[string | number]: any} = {
	"queueonteleport",
	"setrbxclipboard",

	"setsimulationradius",
	"clearqueueonteleport",

	rconsolecreate = {
		Test = CheckConsole,
		RunLast = true,
	},

	rconsoleprint = {
		Test = CheckConsole,
		RunLast = true,
	},

	rconsoleinfo = {
		Test = CheckConsole,
		RunLast = true,
	},

	rconsolewarn = {
		Test = CheckConsole,
		RunLast = true,
	},

	rconsoleerr = {
		Test = CheckConsole,
		RunLast = true,
	},

	rconsoledestroy = {
		Test = CheckConsole,
		RunLast = true,
	},

	isrbxactive = {
		ReturnType = "boolean",
		Test = function()
			assert(not MissedFocusLoss, "still returned true after the Roblox window lost focus")

			if not HasFocus then
				return
			end

			const function CheckLostFocus()
				return not HasFocus
			end

			const function CheckInactive()
				return HasFocus or not isrbxactive()
			end

			const CreateConsole = rconsolecreate

			if CreateConsole then
				AddCleanup(function()
					rconsoledestroy()
				end)

				pcall(CreateConsole)

				if WaitFor(CheckLostFocus, 1) then
					assert(WaitFor(CheckInactive, 1), "still returned true after the Roblox window lost focus")
					return
				end
			end

			const MessageBox = messagebox

			if not MessageBox then
				return
			end

			const BoxStartTime = tick()

			task.spawn(pcall, MessageBox, "debUNC test, you can close this", "debUNC", 0)

			MessageBoxTime = tick() - BoxStartTime

			if not WaitFor(CheckLostFocus, 2) then
				return
			end

			assert(WaitFor(CheckInactive, 1), "still returned true after the Roblox window lost focus")
		end,
		RunLast = true,
	},
}

for Index, Info in NoTests do
	assert(not Tests[Index] and not Tests[Info], `a test for {Index} or {Info} already exists`)

	if typeof(Index) == "string" then
		Tests[Index] = Info
		continue
	end

	Tests[Info] = {}
end

const GetGlobalEnvironment: () -> {[string]: any} = getgenv or function()
	return {}
end

const function RestoreFunctions()
	const GlobalEnvironment = GetGlobalEnvironment()

	if not GlobalEnvironment.OriginalFunctions then
		return
	end

	for Name, OriginalFunction in GlobalEnvironment.OriginalFunctions do
		getfenv()[Name] = OriginalFunction
	end

	for Name in GlobalEnvironment.NonExistentFunctions do
		getfenv()[Name] = nil
	end

	GlobalEnvironment.OriginalFunctions = nil
end

RestoreFunctions()

local ExecutorName, ExecutorVersion = (identifyexecutor or function()
	return "Unknown Executor", "0.0.0"
end)()

ExecutorName = ExecutorName or "Unknown Executor"
ExecutorVersion = ExecutorVersion or "0.0.0"

const function DisplayMessage(Message: string)
	if ExecutorName == "AWP" then
		print(Message)
		return
	end

	if not pcall(game:GetService("TestService").Message, game:GetService("TestService"), Message) then
		print(Message)
	end
end

const Settings: {[string]: any} = {
	FakeFunctions = false,
	GetTests = false,
	GetUnaddedFunctions = false,
	DebugMode = false,
	CrashTests = false,
}

for Name, Value in shared.Settings or {} do
	Settings[Name] = Value
end

for Name in Settings do
	const Saved = shared[Name]

	if Saved == nil then
		continue
	end

	Settings[Name] = Saved
end

if Settings.CrashTests then
	Tests["crash: hooking a running proto"] = {
		Test = function()
			assert(loadstring([[
				local Proto

				local function Outer()
					local function Inner(Depth)
						if Depth == 1 then
							hookproto(Proto, function() end)
							pcall(function() fullgc() end)
							pcall(function() collectgarbage("collect") end)

							local Filler = {}

							for Index = 1, 3000 do
								Filler[Index] = {}
							end
						end

						if Depth > 0 then
							return Inner(Depth - 1)
						end
					end

					return Inner
				end

				local Running = Outer()

				Proto = debug.getproto(Outer, 1)
				Running(2)
				restoreproto(Proto)
			]]))()
		end,
		Security = true,
		RunLast = true,
	}
end

pcall(game:GetService("StarterGui").SetCore, game:GetService("StarterGui"), "DevConsoleVisible", true)

DisplayMessage("If your Roblox crashes or freezes during these tests, run `shared.DebugMode = true` before debUNC to prevent it or find the crashing function.")

const IsFunctionHooked = isfunctionhooked

if Settings.FakeFunctions then
	const NewCClosure: ((...any) -> ...any) -> (...any) -> ...any = newcclosure
	const OriginalFunctions = {}
	const NonExistentFunctions = {}

	DisplayMessage("Faking functions is enabled")

	for FunctionName in Tests do
		if FunctionName == "getgenv" or FunctionName == "newcclosure" or Tests[FunctionName].Security then
			continue
		end

		const LibraryName, MemberName = FunctionName:match("^([^.]+)%.([^.]+)$")

		if LibraryName then
			const OriginalLibrary = getfenv()[LibraryName]

			if typeof(OriginalLibrary) ~= "table" then
				continue
			end

			if OriginalFunctions[LibraryName] == nil then
				OriginalFunctions[LibraryName] = OriginalLibrary
				getfenv()[LibraryName] = table.clone(OriginalLibrary)
			end

			getfenv()[LibraryName][MemberName] = NewCClosure(function() end)
			continue
		end

		if not getfenv()[FunctionName] then
			NonExistentFunctions[FunctionName] = true
		end

		OriginalFunctions[FunctionName] = getfenv()[FunctionName]
		getfenv()[FunctionName] = NewCClosure(function() end)
	end

	GetGlobalEnvironment().OriginalFunctions = OriginalFunctions
	GetGlobalEnvironment().NonExistentFunctions = NonExistentFunctions
end

const function StartCallLogging()
	const HookFunction = hookfunction
	const WriteFile = writefile
	const AppendFile = appendfile
	const RestoreFunction = restorefunction
	const CheckCaller = checkcaller

	if not HookFunction or not WriteFile then
		return
	end

	const Blacklist = {
		"__ws_poll",
		"__ws_send",
		"hookfunction",
		"info",
		"print",
		"profilebegin",
		"profileend",
		"tostring",
		"wait",
		"writefile",
	}

	const HookedTables = {}
	const HookedFunctions = {}

	local Log = ""
	local Logging = true

	const function Hook(Name, HookedFunction)
		if typeof(HookedFunction) == "table" then
			if HookedTables[HookedFunction] or getmetatable(HookedFunction) ~= nil then
				return
			end

			HookedTables[HookedFunction] = true

			for OtherName, OtherFunction in HookedFunction do
				Hook(OtherName, OtherFunction)
			end
			return
		end

		if table.find(Blacklist, Name) or typeof(HookedFunction) ~= "function" or HookedFunction == CheckCaller then
			return
		end

		local Original
		Original = HookFunction(HookedFunction, function(...)
			if Logging or (CheckCaller and not CheckCaller()) or tostring((...)) == "WebSocket" then
				return Original(...)
			end

			Logging = true

			const Arguments = {...}
			const Message = `Ran function {Name}`
			const ArgumentNames = {}

			print(Message)

			for _, Argument in Arguments do
				table.insert(ArgumentNames, tostring(Argument))
			end

			const Line = `{Message}{if Arguments[1] then ` with arguments {table.concat(ArgumentNames, ", ")}` else ""}\n`

			if AppendFile then
				AppendFile("LogFunctionCalls.txt", Line)
			else
				Log ..= Line
				WriteFile("LogFunctionCalls.txt", Log)
			end

			Logging = false

			task.wait(0.1)

			return Original(...)
		end)

		HookedFunctions[HookedFunction] = Original
	end

	WriteFile("LogFunctionCalls.txt", "")
	for Name, GlobalFunction in GetGlobalEnvironment() do
		Hook(Name, GlobalFunction)
	end

	print("Started logging function calls")

	Logging = false

	return function()
		Logging = true

		for HookedFunction, Original in HookedFunctions do
			if RestoreFunction and pcall(RestoreFunction, HookedFunction) then
				continue
			end

			pcall(HookFunction, HookedFunction, Original)
		end
	end
end

local StopCallLogging

if Settings.DebugMode then
	DisplayMessage("Debug Mode is enabled!")
	StopCallLogging = StartCallLogging()
end

if IsFunctionHooked and not Settings.DebugMode then
	assert(IsFunctionHooked(pcall) == false, "tests can't run if pcall is hooked")
	assert(IsFunctionHooked(loadstring) == false, "tests can't run if loadstring is hooked")
end

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0
local MissingFunctions = 0
local UntestableTests = 0
local EnvironmentSkips = 0

const Results: {[string]: string} = {}
const FailureMessages: {[string]: string} = {}

const function RunTest(Name: string, Info: any)
	TestThreads[coroutine.running()] = Name

	local Missing = false
	local TestedAlias = ""

	local Success, ErrorMessage = pcall(function()
		if not Info.Security then
			local TestedValue = FindFirstFunction(Name)

			for _, OtherName in Info.OtherNames or {} do
				if TestedValue then
					break
				end

				TestedValue = FindFirstFunction(OtherName)
				TestedAlias = if TestedValue then ` ({OtherName})` else ""
			end

			const ValueType = Info.ValueType or "function"

			Missing = TestedValue == nil

			assert(TestedValue, "doesn't exist")
			assert(typeof(TestedValue) == ValueType, `doesn't have '{ValueType}' type`)

			if IsFunctionHooked and ValueType == "function" and not Settings.DebugMode then
				assert(IsFunctionHooked(TestedValue) == false, "the function is hooked and can't be tested accurately")
			end

			if Info.ReturnType then
				Formatters.CheckReturnType(TestedValue(), Info.ReturnType)
			end
		end

		if not Info.Test then
			return
		end

		if not Info.Retry then
			Info.Test()
			return
		end

		const FirstSuccess, FirstError = pcall(Info.Test)

		if FirstSuccess then
			return
		end

		if typeof(FirstError) == "table" and FirstError.Skipped then
			error(FirstError, 0)
		end

		RunCleanups(coroutine.running())
		Info.Test()
	end)

	TestThreads[coroutine.running()] = nil
	RunCleanups(coroutine.running())

	if Results[Name] then
		return
	end

	TotalTests += 1

	if Success then
		print(`🟢 {Name}{TestedAlias}`)
		Results[Name] = "passed"
		CompletedTests += 1
		return
	end

	if typeof(ErrorMessage) == "table" and ErrorMessage.Skipped then
		warn(`🟠 {Name}: skipped because {ErrorMessage.Skipped}`)
		Results[Name] = "skipped"
		UntestableTests += 1
		EnvironmentSkips += if ErrorMessage.Environment then 1 else 0
		return
	end

	if not Missing and InputTests[Name] and not IsRobloxFocused() then
		warn(`🟠 {Name}: skipped because the Roblox window isn't focused`)
		Results[Name] = "skipped"
		UntestableTests += 1
		EnvironmentSkips += if FocusLost then 1 else 0
		return
	end

	if not Settings.DebugMode then
		ErrorMessage = tostring(ErrorMessage):gsub("^.-:%d+: ", "")
	end

	if Missing then
		warn(`🟡 {Name}`)
		Results[Name] = "missing"
		MissingFunctions += 1
		return
	end

	Results[Name] = "failed"
	FailureMessages[Name] = ErrorMessage
end

const function MarkUnfinished(Name: string)
	if Results[Name] then
		return
	end

	for Thread, TestName in TestThreads do
		if TestName ~= Name then
			continue
		end

		TestThreads[Thread] = nil
		pcall(task.cancel, Thread)
		RunCleanups(Thread)
	end

	TotalTests += 1
	Results[Name] = "failed"
	FailureMessages[Name] = `didn't finish within {if Settings.DebugMode then 600 else 60} seconds`
end

const TestTimeout = if Settings.DebugMode then 600 else 60

const function RunTestAlone(Name: string, Info: any)
	task.spawn(RunTest, Name, Info)

	WaitFor(function()
		return Results[Name] ~= nil
	end, TestTimeout)

	MarkUnfinished(Name)
end

local TestCount = 0
const LastTests = {}

for Name: string, Info in Tests do
	TestCount += 1

	if Info.RunLast then
		table.insert(LastTests, Name)
		continue
	end

	if Settings.DebugMode then
		RunTestAlone(Name, Info)
		task.wait(0.179)
		continue
	end

	task.spawn(RunTest, Name, Info)
	task.wait()
end

const StartTime = tick()

WaitFor(function()
	return TotalTests == TestCount - #LastTests
end, TestTimeout)

for Name, Info in Tests do
	if Info.RunLast then
		continue
	end

	MarkUnfinished(Name)
end

DisplayMessage("Don't touch your mouse or keyboard until the tests finish.")

for _, Name in {"rconsolecreate", "rconsoleprint", "rconsoleinfo", "rconsolewarn", "rconsoleerr", "rconsoledestroy", "isrbxactive"} do
	table.insert(LastTests, table.remove(LastTests, table.find(LastTests, Name)))
end

for _, Name in LastTests do
	RunTestAlone(Name, Tests[Name])
end

FocusConnection:Disconnect()
FocusGainedConnection:Disconnect()

if StopCallLogging then
	StopCallLogging()
end

pcall(function()
	for _, Path in listfiles("") do
		const FileName = Path:match("[^/\\]+$")

		if FileName:match("^File_[%d%.e%-]+%.%a+$") then
			delfile(Path)
		elseif FileName:match("^Folder_[%d%.e%-]+$") then
			delfolder(Path)
		end
	end
end)

for Name, Message in FailureMessages do
	local BlockingDependency
	local BlockingReason

	for Dependency in Dependencies[Name] or {} do
		const DependencyResult = Results[Dependency] or if FindFirstFunction(Dependency) then nil else "missing"
		if (DependencyResult ~= "failed" and DependencyResult ~= "missing") or (Dependencies[Dependency] and Dependencies[Dependency][Name]) then
			continue
		end

		BlockingDependency = Dependency
		BlockingReason = if DependencyResult == "missing" then "is missing" else "failed"
		break
	end

	if BlockingDependency then
		warn(`🟠 {Name}: couldn't be tested because {BlockingDependency} {BlockingReason}`)
		UntestableTests += 1
		continue
	end

	warn(`🔴 {Name}: {Message}`)
	FailedTests += 1
end

const ElapsedTime = tick() - StartTime - MessageBoxTime
const PercentageComplete = math.floor(CompletedTests / math.max(TotalTests - EnvironmentSkips, 1) * 100)
const MinimumSeconds = 0.1

task.wait(0.5)

if ElapsedTime < MinimumSeconds and PercentageComplete > 80 then
	DisplayMessage(`This test is most likely faked as it took less than {MinimumSeconds} seconds.`)
end

DisplayMessage("❓ The score below is only for how many custom functions are supported and secure.")
DisplayMessage(`🔵 debUNC v2.9.0 Score for {ExecutorName} {ExecutorVersion}: {PercentageComplete}%`)
DisplayMessage(`🟣 Total tests: {TotalTests} (Took {math.floor(ElapsedTime * 100) / 100} seconds)`)
DisplayMessage(`🟢 Successful tests: {CompletedTests}`)
DisplayMessage(`🔴 Failed tests: {FailedTests}`)
DisplayMessage(`🟠 Skipped tests: {UntestableTests}`)
DisplayMessage(`🟡 Missing functions: {MissingFunctions}`)

const function Divider()
	print("---------------------------------------------------------------------------------------------------------")
end

Divider()

print("debUNC shared Settings:")

Divider()

for Name: string, Enabled: boolean in Settings do
	print(`{Name}: {Enabled}`)
end

Divider()

RestoreFunctions()

if not Settings.GetUnaddedFunctions and not Settings.GetTests then
	return
end

print("A list of functions and libraries in getfenv() and getgenv() that aren't added to the test.")

Divider()

const Blacklist = {
	"aunisgay",
	"aunisafemboy",
	"iusets is a skid",
	"queue_on_teleport",
	"hookfunc",
	"http.request",
}

const GetRobloxEnvironment = getrenv
const RobloxEnvironment = GetRobloxEnvironment and GetRobloxEnvironment() or {}
const AlreadyChecked = {}
const VisitedTables = {}

local Copy = ""

const function GetFromEnvironment(Environment, GetTests: boolean?, Library: string?)
	if VisitedTables[Environment] then
		return
	end

	VisitedTables[Environment] = true

	for Name: any, Value: any in Environment do
		if typeof(Name) ~= "string" then
			continue
		end

		if Library then
			Name = `{Library}.{Name}`
		end

		if not GetTests and (
			Tests[Name]
			or (Name:find("_") and Tests[(Name:gsub("_", ""))])
			or (typeof(Value) ~= "function" and typeof(Value) ~= "table")
			or FindFirstFunction(Name, RobloxEnvironment) ~= nil
			or AlreadyChecked[Name]
			or table.find(Blacklist, Name)
		) then
			continue
		end

		if typeof(Value) == "table" and getmetatable(Value) ~= nil then
			continue
		end

		if typeof(Value) == "table" and not Settings.GetTests then
			GetFromEnvironment(Value, false, Name)
			continue
		end

		AlreadyChecked[Name] = true

		const Message = `"{Name}",`

		Copy ..= `{Message}\n`
		print(Message)
	end
end

if Settings.GetTests then
	GetFromEnvironment(Tests, true)
else
	GetFromEnvironment(getfenv())
	GetFromEnvironment(GetGlobalEnvironment())
end

if Copy == "" then
	print("No unadded functions found.")
	Divider()
	return
end

Divider()

const SetClipboard = setclipboard

if not SetClipboard then
	return
end

SetClipboard(Copy)
print("^ Copied to your clipboard! ^")

Divider()