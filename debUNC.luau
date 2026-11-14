--!strict
type Function = (...any) -> ...any?

const EncodingService = game:GetService("EncodingService")
const LogService = game:GetService("LogService")
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
	const StartTime = os.clock()

	repeat
		task.wait()
	until Check() or os.clock() - StartTime >= Timeout

	return Check()
end

const function CreateRandomString(Length: number): string
	const Characters = table.create(Length)

	for Index = 1, Length do
		Characters[Index] = string.char(math.random(0, 255))
	end

	return table.concat(Characters)
end

const AllBytes = (function()
	const Characters = table.create(256)

	for Byte = 0, 255 do
		Characters[Byte + 1] = string.char(Byte)
	end

	return table.concat(Characters)
end)()

local HasFocus = true
local MissedFocusLoss = false
local MessageBoxTime = 0

const FocusConnection = UserInputService.WindowFocusReleased:Connect(function()
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
const InputInterference: {[string]: boolean} = {}
local FocusStuck = false

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

const function MoveFocusToConsole()
	if not IsRobloxFocused() then
		return
	end

	const CreateConsole = rconsolecreate

	if not CreateConsole then
		FocusStuck = true
		return
	end

	pcall(CreateConsole)
	pcall(rconsoleshow or function() end)

	FocusStuck = not WaitFor(function()
		return not IsRobloxFocused()
	end, 2)
end

const function CheckInputFree(IsOwnInput: ((InputObject) -> boolean)?)
	const TestName = TestThreads[coroutine.running()]

	if TestName then
		InputTests[TestName] = true
	end

	const IdentifyExecutor = identifyexecutor

	const ExecutorName = IdentifyExecutor and tostring((IdentifyExecutor()))

	if ExecutorName and table.find({"athena", "bunni"}, ExecutorName:lower()) and not IsRobloxFocused() then
		error(`input only works while Roblox is focused, {ExecutorName} sends it to whatever window is focused instead`)
	end

	if FocusStuck and isrbxactive and IsRobloxFocused() and not UserInputService.TouchEnabled then
		error({Skipped = "rconsolecreate and messagebox aren't able to capture focus, so you'll have to run debUNC with roblox unfocused yourself"})
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

	if not TestName then
		return
	end

	InputInterference[TestName] = false

	const InterferenceConnection = UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.Keyboard and not Input.UserInputType.Name:find("^MouseButton") then
			return
		end

		if IsOwnInput and IsOwnInput(Input) then
			return
		end

		InputInterference[TestName] = true
	end)

	AddCleanup(function()
		InterferenceConnection:Disconnect()
	end)
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
	local Held = true

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
			Held = Detected and WaitFor(IsHeld, 1)
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
	assert(Held, "the input wasn't held down after being pressed, it should stay held until it's released")
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

	CheckInputFree(function(Input)
		return Input.UserInputType == InputType
	end)
	CenterMouse()

	CheckPressAndRelease(`mouse{Button}press`, `mouse{Button}release`, TestedName, function()
		return UserInputService:IsMouseButtonPressed(InputType) or TouchHeld
	end, function(Input)
		return Input.UserInputType == InputType or (Button == 1 and Input.UserInputType == Enum.UserInputType.Touch)
	end)
end

const function IsTestKey(Input: InputObject): boolean
	return Input.KeyCode == Enum.KeyCode.F13
end

const function CheckKey(TestedName: string)
	CheckInputFree(IsTestKey)

	CheckPressAndRelease("keypress", "keyrelease", TestedName, function()
		return UserInputService:IsKeyDown(Enum.KeyCode.F13)
	end, IsTestKey, 0x7C)
end

const function CheckPacketHook(Direction: string, CheckRemove: boolean)
	const RakNet = raknet
	const AddHook = RakNet[`add{Direction}hook`]
	const RemoveHook = RakNet[`remove{Direction}hook`]

	local Count = 0
	local ControlCount = 0
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

	const function OnControlPacket()
		ControlCount += 1
	end

	AddCleanup(function()
		RemoveHook(OnPacket)
	end)

	AddHook(OnPacket)

	const Fired = WaitFor(function()
		return Count > 0
	end, 3)

	if CheckRemove and not Fired then
		error({Skipped = `the {Direction} hook never fired, so removing it can't be checked`})
	end

	if CheckRemove then
		AddCleanup(function()
			RemoveHook(OnControlPacket)
		end)

		AddHook(OnControlPacket)
	end

	RemoveHook(OnPacket)

	const CountAtRemoval = Count
	const ControlCountAtRemoval = ControlCount

	assert(Fired, `the {Direction} hook wasn't called within 3 seconds`)
	assert(typeof(PacketId) == "number", `expected the packet to have a number PacketId, got {typeof(PacketId)}`)
	assert(MatchedData, "the packet's Size, AsString and AsBuffer don't match each other")

	if not CheckRemove then
		return
	end

	WaitFor(function()
		return ControlCount >= ControlCountAtRemoval + 3
	end, 3)

	if ControlCount == 0 then
		error({Skipped = `the second {Direction} hook never fired, so it can't check removing a hook`})
	end

	assert(ControlCount > ControlCountAtRemoval, `removing one {Direction} hook also stopped the other {Direction} hooks, it should only remove the one given`)
	assert(Count == CountAtRemoval, `the {Direction} hook was still called after it was removed`)
end

const function RunOnNewActor(Code: string, ...: any): {[string]: any}
	const RunOnActor = Formatters.CheckExist("runonactor")
	const Actor = Instance.new("Actor")

	Actor.Parent = workspace
	AddCleanup(function()
		Actor:Destroy()
	end)

	RunOnActor(Actor, `local Actor = ... {Code} Actor:SetAttribute("Done", true)`, Actor, ...)

	const Done = WaitFor(function()
		return Actor:GetAttribute("Done") == true
	end, 2)

	const Attributes = Actor:GetAttributes()

	Actor:Destroy()

	assert(Done, "the code ran on the actor never finished within 2 seconds")

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
	const GetClipboard = Formatters.CheckExist("getclipboard")

	const SetClipboard = Formatters.CheckExist("setclipboard")
	const Previous = GetClipboard()
	const Text = `debUNC{math.random(1, 1e6)}`

	AddCleanup(function()
		SetClipboard(Previous)
	end)

	SetClipboard(Text)

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

const function CheckServerAvailable(Success: boolean, Response: any)
	if not Success then
		error({Skipped = `couldn't reach the server, got {Response}`, Environment = true})
	end

	const Body = string.lower(tostring(Response))

	for _, Phrase in {
		"too many requests",
		"rate limit",
		"used your quota",
		"bad gateway",
		"service unavailable",
		"temporarily unavailable",
		"gateway time",
	} do
		if Body:find(Phrase, 1, true) then
			error({Skipped = `the server is rate limiting or down, it answered with '{Body:sub(1, 80)}'`, Environment = true})
		end
	end
end

const function FindWrongReference(Object: any, References: {any}): any?
	const GetUpvalues = FindFirstFunction("debug.getupvalues")

	const function HasValue(Table: {[any]: any}): boolean
		for _, Value in next, Table do
			if rawequal(Value, Object) then
				return true
			end
		end

		return false
	end

	for _, Reference in References do
		if typeof(Reference) == "table" then
			if rawequal(getmetatable(Reference), Object) or rawget(Reference, Object) ~= nil or HasValue(Reference) then
				continue
			end

			return Reference
		end

		if typeof(Reference) ~= "function" or not GetUpvalues or debug.info(Reference, "s") == "[C]" then
			continue
		end

		const Success, Upvalues = pcall(GetUpvalues, Reference)

		if not Success or typeof(Upvalues) ~= "table" or HasValue(Upvalues) then
			continue
		end

		return Reference
	end

	return nil
end

const function RunOnGameThread(Callback: () -> ...any): ...any
	const ControlModule = GetPlayerModule():FindFirstChild("ControlModule")
	const BaseCharacterController = ControlModule and ControlModule:FindFirstChild("BaseCharacterController")

	if not BaseCharacterController then
		error({Skipped = "this game has no ControlModule with a BaseCharacterController", Environment = true})
	end

	const Success, Controller = pcall(require, BaseCharacterController)

	assert(Success, `failed to require BaseCharacterController with the error {Controller}`)

	const Old = Controller.GetMoveVector
	local Results

	AddCleanup(function()
		Controller.GetMoveVector = Old
	end)

	Controller.GetMoveVector = function(...)
		Controller.GetMoveVector = Old
		Results = table.pack(pcall(Callback))
		return Old(...)
	end

	WaitFor(function()
		return Results ~= nil
	end, 2)

	Controller.GetMoveVector = Old

	if not Results then
		error({Skipped = "the ControlModule never called the hooked function", Environment = true})
	end

	if not Results[1] then
		error(Results[2], 0)
	end

	return table.unpack(Results, 2, Results.n)
end

const TeleportResults: {[string]: boolean} = {}

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

			const Key = `debUNC{math.random(1, 1e6)}`
			const Value = math.random()

			AddCleanup(function()
				Environment[Key] = nil
			end)

			Environment[Key] = Value

			const Stored = getrenv()[Key]

			assert(Environment.game == game, "its 'game' isn't the real game")
			assert(Environment.print == print, "its 'print' isn't the real print")
			assert(Environment._G ~= _G, "its _G is the same as the executor's _G")
			assert(Environment ~= getgenv(), "it's the same table as getgenv(), not Roblox's environment")
			assert(Environment.getgenv == nil and Environment.hookfunction == nil, "it has executor functions in it, so game scripts can find them")
			Formatters.CheckEqual(Stored, Value, "a value written to it")

			const GetScriptEnvironment = Formatters.CheckExist("getsenv")
			const Animate = Player.Character and Player.Character:FindFirstChild("Animate")

			if not Animate then
				error({Skipped = "your character has no Animate script to compare environments with", Environment = true})
			end

			const ScriptEnvironment = GetScriptEnvironment(Animate)

			assert(ScriptEnvironment, "couldn't get the Animate script's environment to compare with")

			Environment[Key] = nil

			assert(ScriptEnvironment._G == Environment._G, "its _G isn't the same _G game scripts use")
			assert(ScriptEnvironment.shared == Environment.shared, "its shared isn't the same shared game scripts use")
			assert(Environment.printidentity == printidentity and ScriptEnvironment.printidentity == printidentity, "printidentity isn't the same function everywhere, so it's been replaced in one environment")
			assert(Formatters.CheckExist("debug.info")(printidentity, "s") == "[C]" and debug.info(printidentity, "n") == "printidentity", "printidentity isn't Roblox's real C function anymore")
			assert(not pcall(setfenv, printidentity, getfenv()), "setfenv worked on printidentity, so it's a LuaClosure pretending to be Roblox's")

			for _, Name in {
				"getgenv",
				"hookfunction",
				"identifyexecutor",
				"getrenv",
				"newcclosure",
			} do
				for Place, Table in {
					["a game script's environment"] = ScriptEnvironment,
					["the game's _G"] = Environment._G,
					["the game's shared"] = Environment.shared,
				} do
					assert(rawget(Table, Name) == nil and Table[Name] == nil, `{Name} can be reached from {Place}, so game scripts can detect the executor`)
				end
			end
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

			const CurrentEnvironment = getfenv(0)

			assert(
				GetThreadEnvironment() == CurrentEnvironment and GetThreadEnvironment(coroutine.running()) == CurrentEnvironment,
				"with no thread given, it should return the current thread's environment"
			)

			const Thread = task.spawn(function()
				task.wait(1)
			end)

			AddCleanup(function()
				task.cancel(Thread)
			end)

			const ThreadEnvironment = GetThreadEnvironment(Thread)

			Formatters.CheckReturnType(ThreadEnvironment, "table")

			assert(ThreadEnvironment == CurrentEnvironment, "a thread started by this thread should have the same environment as it")

			const Finished = task.spawn(function() end)
			const Success, FinishedEnvironment = pcall(GetThreadEnvironment, Finished)

			assert(Success and FinishedEnvironment == CurrentEnvironment, "didn't keep the environment of a thread that already finished")

			const GetScriptThread = Formatters.CheckExist("getscriptthread")

			local GameScript
			local GameThread

			for _, Descendant in GetPlayerScripts():GetDescendants() do
				if not Descendant:IsA("LocalScript") then
					continue
				end

				GameScript = Descendant
				GameThread = GetScriptThread(Descendant)

				if GameThread then
					break
				end
			end

			if typeof(GameThread) ~= "thread" then
				error({Skipped = "no LocalScript has a running thread to get the environment of", Environment = true})
			end

			const GameEnvironment = GetThreadEnvironment(GameThread)

			Formatters.CheckReturnType(GameEnvironment, "table")

			assert(GameEnvironment ~= CurrentEnvironment, "a game script's thread gave the executor's environment instead of its own")
			assert(GameEnvironment.script == GameScript, `the environment of {GameScript.Name}'s thread doesn't have {GameScript.Name} as its script`)
			assert(GameEnvironment.getgenv == nil, "a game script's thread environment has executor functions in it, they should only be in the executor's")
		end,
	},

	readfile = {
		Test = function()
			const ReadFile: (Path: string) -> string = readfile

			assert(not pcall(ReadFile, `Missing_{math.random()}.txt`), "expected an error when reading a file that doesn't exist")

			const GeneratedResult = `{math.random()}\0debUNC`
			const FileName = `File_{math.random()}.txt`

			Formatters.CheckExist("writefile")(FileName, GeneratedResult)
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const Result = ReadFile(FileName)

			Formatters.CheckExist("writefile")(FileName, "")

			const EmptyResult = ReadFile(FileName)

			RemovePath("delfile", FileName)

			assert(Result == GeneratedResult, "the test file didn't return what was written into it")
			Formatters.CheckEqual(EmptyResult, "", "an empty file's contents")
		end,
	},

	writefile = {
		Test = function()
			const ReadFile: (Path: string) -> string = Formatters.CheckExist("readfile")

			const GeneratedResult = `{math.random()}\0debUNC`
			const FileName = `File_{math.random()}.txt`

			writefile(FileName, GeneratedResult)
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const Result = ReadFile(FileName)

			writefile(FileName, "debUNC")

			const ShorterResult = ReadFile(FileName)
			const Large = CreateRandomString(1024 * 1024)

			writefile(FileName, Large)

			const LargeIntact = ReadFile(FileName) == Large
			const Bytes = `{AllBytes}\r\n{AllBytes}\n\r`

			writefile(FileName, Bytes)

			const BytesResult = ReadFile(FileName)

			RemovePath("delfile", FileName)

			assert(typeof(Result) == "string", "'readfile' failed to read the file, can't continue the test")
			assert(Result == GeneratedResult, "'writefile' didn't write to the file")
			assert(LargeIntact, "a 1 MB file didn't read back the same as what was written")
			Formatters.CheckEqual(ShorterResult, "debUNC", "the file after writing shorter text over it")
			assert(#BytesResult == #Bytes, `writing every byte with line endings read back as {#BytesResult} bytes instead of {#Bytes}, so some bytes or line endings were changed`)
			assert(BytesResult == Bytes, "writing every byte with line endings didn't read back the same as what was written")
		end,
	},

	isfile = {
		Test = function()
			const IsFile = isfile
			const FileName = `File_{math.random()}.txt`
			const FolderName = `Folder_{math.random()}`

			Formatters.CheckExist("writefile")(FileName, "Test")
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const Exists = IsFile(FileName)

			RemovePath("delfile", FileName)

			assert(Exists, "failed to find the file")
			assert(IsFile(`Missing_{math.random()}.txt`) == false, "found a file that doesn't exist")

			Formatters.CheckExist("makefolder")(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			const FolderIsFile = IsFile(FolderName)

			RemovePath("delfolder", FolderName)

			assert(FolderIsFile == false, "said a folder is a file")
		end,
	},

	appendfile = {
		Test = function()
			const AppendFile: (Path: string, Data: string) -> () = appendfile
			const ReadFile: (Path: string) -> string = Formatters.CheckExist("readfile")

			const GeneratedResult = tostring(math.random())
			const FileName = `File_{math.random()}.txt`

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			if not pcall(AppendFile, FileName, GeneratedResult) then
				Formatters.CheckExist("writefile")(FileName, GeneratedResult)
			end

			const Created = ReadFile(FileName) == GeneratedResult

			AppendFile(FileName, "Append")

			const Result = ReadFile(FileName)

			AppendFile(FileName, "\0Again\r\n")

			const SecondResult = ReadFile(FileName)

			RemovePath("delfile", FileName)

			assert(Created, "failed to create the file")
			Formatters.CheckEqual(Result, `{GeneratedResult}Append`, "the file's text after adding to it")
			assert(SecondResult == `{GeneratedResult}Append\0Again\r\n`, "appending a null character and a line ending didn't add the same text to the end of the file")
		end,
	},

	listfiles = {
		Test = function()
			const ListFiles: (Path: string) -> {string} = listfiles

			const FolderName = `Folder_{math.random()}`
			const FileName = `{FolderName}/File_{math.random()}.txt`
			const InnerFolder = `{FolderName}/Inner`

			Formatters.CheckExist("makefolder")(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			const ReturnedTable = typeof(ListFiles(FolderName)) == "table"

			Formatters.CheckExist("writefile")(FileName, tostring(math.random()))
			Formatters.CheckExist("makefolder")(InnerFolder)
			Formatters.CheckExist("writefile")(`{InnerFolder}/Deeper.txt`, "debUNC")

			const Result = ListFiles(FolderName)

			RemovePath("delfolder", FolderName)

			const Found = {}

			for _, Path in Result do
				Found[(Path:gsub("\\", "/"):gsub("/$", ""):gsub("^%./", ""))] = true
			end

			assert(ReturnedTable, "didn't return a table")
			assert(Found[FileName], "didn't find the written file")
			assert(Found[InnerFolder], "didn't find the folder inside it")
			Formatters.CheckEqual(#Result, 2, "the number of things listed, since only the folder's direct children should be there,")
		end,
	},

	delfile = {
		Test = function()
			const IsFile: (Path: string) -> boolean = Formatters.CheckExist("isfile")
			const WriteFile = Formatters.CheckExist("writefile")

			const FileName = `File_{math.random()}.txt`
			const SiblingName = `File_{math.random()}.txt`
			const SiblingContents = tostring(math.random())

			WriteFile(FileName, "Test")
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)
			WriteFile(SiblingName, SiblingContents)
			AddCleanup(function()
				RemovePath("delfile", SiblingName)
			end)

			assert(IsFile(FileName), "failed to write to the file, can't continue the test")

			delfile(FileName)

			assert(not IsFile(FileName), "'isfile' returned true after the file was meant to be deleted")
			assert(IsFile(SiblingName), "deleting one file also deleted the file next to it")
			Formatters.CheckEqual(Formatters.CheckExist("readfile")(SiblingName), SiblingContents, "the contents of the file next to the deleted one")
		end,
	},

	loadfile = {
		Test = function()
			const FileName = `File_{math.random()}.txt`
			const GeneratedNumber = math.random()
			const Offset = math.random(1, 1e6)

			Formatters.CheckExist("writefile")(FileName, `local Number = ...; return Number + {Offset}`)
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const LoadedFunction, ErrorMessage = loadfile(FileName)

			RemovePath("delfile", FileName)

			assert(assert(LoadedFunction, ErrorMessage)(GeneratedNumber) == GeneratedNumber + Offset, "didn't return the correct number")

			const MissingSuccess, MissingFunction = pcall(loadfile, `Missing_{math.random()}.txt`)

			assert(not MissingSuccess or MissingFunction == nil, "returned a function for a file that doesn't exist")
		end,
	},

	makefolder = {
		Test = function()
			const IsFolder: (Path: string) -> boolean = Formatters.CheckExist("isfolder")
			const ReadFile: (Path: string) -> string = Formatters.CheckExist("readfile")
			const WriteFile = Formatters.CheckExist("writefile")

			const FolderName = `Folder_{math.random()}`
			const InnerFolder = `{FolderName}/Inner`
			const InnerFile = `{FolderName}/File.txt`
			const InnerContents = tostring(math.random())

			makefolder(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			const Exists = IsFolder(FolderName) == true

			makefolder(InnerFolder)

			const InnerExists = IsFolder(InnerFolder) == true

			WriteFile(InnerFile, InnerContents)
			makefolder(FolderName)

			const KeptSuccess, KeptContents = pcall(ReadFile, InnerFile)
			const InnerKept = IsFolder(InnerFolder) == true

			RemovePath("delfolder", FolderName)

			assert(Exists, "failed to find the folder after it was made")
			assert(InnerExists, "couldn't find a folder made inside of another folder")
			assert(KeptSuccess and KeptContents == InnerContents, "calling it on a folder that already exists deleted the file inside of it")
			assert(InnerKept, "calling it on a folder that already exists deleted the folder inside of it")

			const FileName = `File_{math.random()}.txt`

			WriteFile(FileName, "debUNC")
			AddCleanup(function()
				RemovePath("delfile", FileName)
				RemovePath("delfolder", FileName)
			end)
			pcall(makefolder, FileName)

			const Success, Contents = pcall(ReadFile, FileName)

			RemovePath("delfile", FileName)
			RemovePath("delfolder", FileName)

			assert(Success, "the file was gone after makefolder was called on its path")

			Formatters.CheckEqual(Contents, "debUNC", "a file after makefolder was called on its path")
		end,
	},

	isfolder = {
		Test = function()
			const IsFolder: (Path: string) -> boolean = isfolder

			assert(IsFolder(`Missing_{math.random()}`) == false, "didn't return false for a folder that doesn't exist")

			const FolderName = `Folder_{math.random()}`
			const FileName = `File_{math.random()}.txt`

			Formatters.CheckExist("makefolder")(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			const Exists = IsFolder(FolderName)

			RemovePath("delfolder", FolderName)

			assert(Exists, "the folder wasn't found after it was made")

			Formatters.CheckExist("writefile")(FileName, "debUNC")
			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const FileIsFolder = IsFolder(FileName)

			RemovePath("delfile", FileName)

			assert(FileIsFolder == false, "said a file is a folder")
		end,
	},

	delfolder = {
		Test = function()
			const IsFolder: (Path: string) -> boolean = Formatters.CheckExist("isfolder")
			const IsFile: (Path: string) -> boolean = Formatters.CheckExist("isfile")
			const MakeFolder = Formatters.CheckExist("makefolder")
			const WriteFile = Formatters.CheckExist("writefile")

			const FolderName = `Folder_{math.random()}`
			const SiblingName = `Folder_{math.random()}`
			const InnerFolder = `{FolderName}/Inner`

			MakeFolder(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)
			MakeFolder(SiblingName)
			AddCleanup(function()
				RemovePath("delfolder", SiblingName)
			end)

			assert(IsFolder(FolderName), "failed to find the folder after it was made")

			WriteFile(`{FolderName}/File.txt`, "debUNC")
			MakeFolder(InnerFolder)
			WriteFile(`{InnerFolder}/Deeper.txt`, "debUNC")
			WriteFile(`{SiblingName}/File.txt`, "debUNC")
			delfolder(FolderName)

			assert(not IsFolder(FolderName), "'isfolder' found a folder with a file in it after it should've been deleted")
			assert(not IsFolder(InnerFolder), "the folder inside of the deleted folder is still there")
			assert(not IsFile(`{FolderName}/File.txt`), "the file inside of the deleted folder is still there")
			assert(not IsFile(`{InnerFolder}/Deeper.txt`), "the file inside of the deleted folder's inner folder is still there")
			assert(IsFolder(SiblingName) and IsFile(`{SiblingName}/File.txt`), "deleting one folder also deleted the folder next to it")
		end,
	},

	hookfunction = {
		Test = function()
			const HookFunction: (FunctionToHook: (...any) -> (...any), Hook: (...any) -> ()) -> () -> () = hookfunction
			const NewCClosure: (((...any) -> ...any) -> (...any) -> ...any)? = newcclosure
			const RestoreFunction = restorefunction

			const function HookAndRestore(CClosure: any, Hook: Function, ...): (boolean, any)
				const Original = HookFunction(CClosure, Hook)

				local Restored = false

				AddCleanup(function()
					if Restored then
						return
					end

					if not pcall(RestoreFunction, CClosure) then
						HookFunction(CClosure, Original)
					end
				end)

				const Success, Result = pcall(CClosure, ...)

				RestoreFunction(CClosure)
				Restored = true

				return Success, Result
			end

			do
				const function FirstFunction()
					return true
				end

				const Original = HookFunction(FirstFunction, function()
					return false
				end)

				assert(typeof(Original) == "function", `should return the original function, got {typeof(Original)}`)

				const HookedResult = FirstFunction()

				HookFunction(FirstFunction, Original)

				assert(Original() == true, "the returned function isn't giving the expected result when called")
				assert(HookedResult == false, "the hooked function didn't return the hook's result")
				assert(FirstFunction() == true, "hooking the function back to the returned original didn't restore it")
			end

			do
				local OriginalRuns, HookRuns = 0, 0

				const function Target()
					OriginalRuns += 1

					return "debUNC Original"
				end

				local HookArguments

				const Environment = getfenv(Target)
				const function Hook(...)
					HookRuns += 1
					HookArguments = table.pack(...)

					return "debUNC Hooked"
				end

				setfenv(Hook, setmetatable({}, {__index = Environment}))

				const Original = HookFunction(Target, Hook)
				const Result = Target(Environment, "debUNC", nil)
				const OriginalRunsFromHookedCall = OriginalRuns

				assert(
					HookArguments and HookArguments.n == 3 and HookArguments[1] == Environment and HookArguments[2] == "debUNC" and HookArguments[3] == nil,
					"the hook didn't get the same args the hooked function was called with"
				)

				assert(Original ~= Target, "returned the hooked function itself instead of a separate original")
				Formatters.CheckEqual(Result, "debUNC Hooked", "the hooked function's result")
				Formatters.CheckEqual(HookRuns, 1, "the number of times the hook ran for one call")
				Formatters.CheckEqual(OriginalRunsFromHookedCall, 0, "the number of times the original ran when only the hooked function was called")
				Formatters.CheckEqual(Original(), "debUNC Original", "the returned original's result")
				assert(RunOnGameThread(function()
					return getfenv(Target)
				end) == Environment, "the hooked function took on the hook's environment, so getfenv can tell it was hooked")
			end

			do
				const IsLoaded = game.IsLoaded
				local Restored = false
				local HookedSelf

				const Original = HookFunction(IsLoaded, function(Self)
					HookedSelf = Self
					return "debUNC"
				end)

				AddCleanup(function()
					if not Restored then
						HookFunction(IsLoaded, Original)
					end
				end)

				const HookedResult = IsLoaded(game)
				const OriginalResult = Original(game)

				HookFunction(IsLoaded, Original)
				Restored = true

				Formatters.CheckEqual(HookedResult, "debUNC", "game.IsLoaded's result while hooked")
				assert(HookedSelf == game, "the hook on game.IsLoaded didn't get game as its first arg")
				Formatters.CheckEqual(OriginalResult, true, "the result of game.IsLoaded's returned original")
				Formatters.CheckEqual(IsLoaded(game), true, "game.IsLoaded's result after hooking it back")

				const function Target()
					return "debUNC Original"
				end

				HookFunction(Target, game.GetFullName)

				Formatters.CheckEqual(Target(workspace), workspace:GetFullName(), "a function hooked with game.GetFullName, given workspace,")
			end

			do
				const function Target(...)
					return select("#", ...)
				end

				local FirstOriginal
				FirstOriginal = HookFunction(Target, function(...)
					task.wait()
					return FirstOriginal(...) + 1
				end)

				Formatters.CheckEqual(Target(1, nil, nil), 4, "a function with a yielding hook, given 3 arguments ending in nils,")

				local SecondOriginal
				SecondOriginal = HookFunction(Target, function(...)
					return SecondOriginal(...) * 10
				end)

				Formatters.CheckEqual(Target(1, nil, nil), 40, "a function hooked twice, where the second hook's original should call the first hook,")
			end

			do
				const ErrorObject = {}
				const function Target() end

				HookFunction(Target, function()
					error(ErrorObject)
				end)

				const Success, Caught = pcall(Target)

				assert(not Success and Caught == ErrorObject, "an error object thrown inside a hook didn't reach the caller unchanged")
			end

			assert(not pcall(HookFunction, function() end), "hooking a function without giving a hook should error")
			assert(not pcall(HookFunction, 1, function() end), "hooking something that isn't a function should error")

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

			Formatters.CheckExist("newcclosure")
			Formatters.CheckExist("restorefunction")

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
				assert(Formatters.CheckExist("debug.info")(HookedNewCClosure, "s") == "[C]", "a C function hooked with a LuaClosure stopped showing as [C]")
			end

			do
				const function NamedTarget()
					return "debUNC Original"
				end

				const Address = tostring(NamedTarget)
				const Name = debug.info(NamedTarget, "n")

				HookFunction(NamedTarget, NewCClosure(function()
					return "debUNC Hooked"
				end))

				Formatters.CheckEqual(tostring(NamedTarget), Address, "the hooked function's address")
				Formatters.CheckEqual(debug.info(NamedTarget, "n"), Name, "the name of a function hooked with a NewCClosure")
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
			assert(IsCClosure(Formatters.CheckExist("newcclosure")(function() end)) == true, "should return true for a function wrapped with newcclosure")
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

			const HookFunction = Formatters.CheckExist("hookfunction")

			const function Original()
				return "debUNC Original"
			end

			const Clone = clonefunction(Original)

			HookFunction(Original, function()
				return "debUNC Hooked"
			end)

			Formatters.CheckEqual(Clone(), "debUNC Original", "a clone's result after the function it was cloned from got hooked")
		end,
	},

	request = {
		Test = function()
			const HttpService = game:GetService("HttpService")
			const Marker = tostring(math.random(1, 1e9))

			const function Send(Options: {[string]: any}): {[string]: any}
				for Attempt = 1, 3 do
					const Success, Response = pcall(request, Options)

					assert(Success, `the request errored with {Response}`)

					if typeof(Response) ~= "table" or typeof(Response.StatusCode) ~= "number" or Response.StatusCode ~= 429 and Response.StatusCode < 500 then
						return Response
					end

					task.wait(Attempt)
				end

				error({Skipped = "httpbin.org kept rate limiting or failing the requests", Environment = true})
			end

			const Result = Send({
				Url = `https://httpbin.org/get?debunc={Marker}`,
				Method = "GET",
				Headers = {["X-Debunc"] = Marker},
			})

			Formatters.CheckReturnType(Result, "table")

			assert(Result.StatusCode == 200, `failed to request, got status {Result.StatusCode} {Result.StatusMessage}`)
			assert(Result.StatusMessage == "OK", "StatusMessage should be 'OK' when the StatusCode is 200")
			assert(Result.Success == true, `Success should be true when the StatusCode is 200, got {Result.Success}`)
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

			for _, Method in {"POST", "PUT", "PATCH", "DELETE"} do
				const Body = `{Method} {Marker}`
				const MethodResult = Send({
					Url = "https://httpbin.org/anything",
					Method = Method,
					Body = Body,
					Headers = {["Content-Type"] = "text/plain"},
				})
				const MethodDecoded = HttpService:JSONDecode(MethodResult.Body)

				assert(MethodResult.StatusCode == 200 and MethodDecoded.method == Method, `a {Method} request didn't go out as {Method}, got status {MethodResult.StatusCode}`)
				assert(MethodDecoded.data == Body, `the body of a {Method} request didn't reach the server as it was sent, it got '{MethodDecoded.data}'`)
			end

			const Missing = Send({
				Url = "https://httpbin.org/status/404",
				Method = "GET",
			})

			assert(Missing.StatusCode == 404 and Missing.Success == false, `a 404 should come back as a response with Success set to false, got status {Missing.StatusCode} and Success {Missing.Success}`)
			assert(typeof(Missing.Headers) == "table", "the response doesn't have its headers")

			Formatters.CheckEqual(#Send({
				Url = "https://httpbin.org/bytes/1024",
				Method = "GET",
			}).Body, 1024, "the length of 1024 random bytes")
			Formatters.CheckEqual(Send({
				Url = "https://httpbin.org/redirect/2",
				Method = "GET",
			}).StatusCode, 200, "the status after following 2 redirects")

			const Gzip = Send({
				Url = "https://httpbin.org/gzip",
				Method = "GET",
			})
			const GzipSuccess, GzipDecoded = pcall(HttpService.JSONDecode, HttpService, Gzip.Body)

			assert(GzipSuccess and GzipDecoded.gzipped == true, `a gzip response wasn't decoded, got status {Gzip.StatusCode} and body '{tostring(Gzip.Body):sub(1, 40)}'`)

			local Frames = 0
			const StartTime = os.clock()
			const Connection = game:GetService("RunService").Heartbeat:Connect(function()
				Frames += 1
			end)

			AddCleanup(function()
				Connection:Disconnect()
			end)

			Send({
				Url = "https://httpbin.org/delay/2",
				Method = "GET",
			})
			Connection:Disconnect()

			assert(Frames > (os.clock() - StartTime) * 5, `the game froze while waiting for a request, only {Frames} frames ran`)
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

			const ControlModule = Module:FindFirstChild("ControlModule")
			const Original = Module:FindFirstChild("CommonUtils") and Module.CommonUtils:FindFirstChild("CameraWrapper")

			if not ControlModule or not Original then
				error({Skipped = "this game's PlayerModule doesn't have a ControlModule and CommonUtils.CameraWrapper", Environment = true})
			end

			assert(typeof(Result.GetControls) == "function", "the required PlayerModule doesn't have GetControls, so it isn't the real module")
			assert(Result:GetControls() == require(ControlModule), "PlayerModule's GetControls didn't return the same ControlModule as requiring it")

			const Clone = Original:Clone()

			Clone.Parent = Original.Parent
			AddCleanup(function()
				Clone:Destroy()
			end)

			const CloneSuccess, CloneResult = pcall(require, Clone)
			const RequiredAgain = CloneSuccess and require(Clone)

			Clone:Destroy()

			assert(CloneSuccess, `requiring a copy of {Original.Name} errored with {CloneResult}`)
			Formatters.CheckEqual(typeof(CloneResult), typeof(require(Original)), `the type of what a copy of {Original.Name} returned`)
			assert(typeof(CloneResult) ~= "table" or CloneResult ~= require(Original), "requiring a copy of a module returned the original's result instead of running the copy")
			assert(RequiredAgain == CloneResult, "requiring the same copied module twice gave different results")

			for _, ClassName in {"Folder", "LocalScript"} do
				assert(not pcall(require, Instance.new(ClassName)), `should error when passing a {ClassName} as the arg value`)
			end
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

			for _, EventName in {"RightMouseClick", "MouseHoverEnter", "MouseHoverLeave"} do
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

			Part.Position = Vector3.new(0, 10000, 0)

			const MaxActivationDistance = ClickDetector.MaxActivationDistance
			local FarClicked = false

			ClickDetector.MouseClick:Once(function()
				FarClicked = true
			end)

			fireclickdetector(ClickDetector)

			const FiredFar = WaitFor(function()
				return FarClicked
			end, 1)

			Part:Destroy()

			assert(FiredFar, "didn't fire for a ClickDetector 10000 studs away")
			Formatters.CheckEqual(ClickDetector.MaxActivationDistance, MaxActivationDistance, "MaxActivationDistance after firing")
		end,
	},

	fireproximityprompt = {
		Test = function()
			const Part = Instance.new("Part")
			Part.Parent = workspace
			AddCleanup(function()
				Part:Destroy()
			end)

			Part.Anchored = true
			Part.Position = Vector3.new(0, 10000, 0)

			const ProximityPrompt = Instance.new("ProximityPrompt")
			ProximityPrompt.HoldDuration = 5
			ProximityPrompt.Parent = Part

			const Before = {
				HoldDuration = ProximityPrompt.HoldDuration,
				MaxActivationDistance = ProximityPrompt.MaxActivationDistance,
				RequiresLineOfSight = ProximityPrompt.RequiresLineOfSight,
				Enabled = ProximityPrompt.Enabled,
			}

			local WasTriggered = false

			ProximityPrompt.Triggered:Once(function(TriggeringPlayer)
				WasTriggered = TriggeringPlayer == Player
			end)

			fireproximityprompt(ProximityPrompt)

			const Triggered = WaitFor(function()
				return WasTriggered
			end, 1)

			for Property, Value in Before do
				assert((ProximityPrompt :: any)[Property] == Value, `left the prompt's {Property} changed after firing it`)
			end

			Part:Destroy()

			assert(Triggered, "didn't fire within a second for a prompt 10000 studs away with a 5 second HoldDuration")
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

			const Event = Instance.new("BindableEvent")
			local Count

			Event.Event:Once(function(...)
				Count = select("#", ...)
			end)

			firesignal(Event.Event, nil, 2)

			WaitFor(function()
				return Count ~= nil
			end, 1)

			Event:Destroy()

			Formatters.CheckEqual(Count, 2, "the number of values passed when the first one is nil")
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
				table.find(LoadedModules, GetPlayerModule()),
				"couldn't find 'PlayerScripts.PlayerModule' in the returned table"
			)

			const Original = GetPlayerModule():FindFirstChild("CommonUtils") and GetPlayerModule().CommonUtils:FindFirstChild("CameraWrapper")

			if not Original then
				error({Skipped = "this game's PlayerModule doesn't have CommonUtils.CameraWrapper to copy", Environment = true})
			end

			const Clone = Original:Clone()

			Clone.Parent = Original.Parent
			AddCleanup(function()
				Clone:Destroy()
			end)

			const FoundClone = table.find(getloadedmodules(), Clone)
			const RequireSuccess = pcall(Formatters.CheckExist("require"), Clone)
			const FoundRequiredClone = table.find(getloadedmodules(), Clone)

			Clone:Destroy()

			assert(not FoundClone, "found a module that was never required")
			assert(RequireSuccess, "requiring a copy of CameraWrapper failed")
			assert(FoundRequiredClone, "didn't find a copied module after it was required")
		end,
		ReturnType = "table",
	},

	getconnections = {
		Test = function()
			const GetConnections = getconnections
			const NumberValue = Instance.new("NumberValue")
			const GeneratedValue = math.random()

			AddCleanup(function()
				NumberValue:Destroy()
			end)

			local DidChange = false
			local Calls = 0
			local OtherCalls = 0
			local WrongValue

			const function OnChanged(Value)
				Calls += 1

				if Value ~= GeneratedValue then
					WrongValue = WrongValue or Value
					return
				end

				DidChange = true
			end

			const function OnOtherChanged()
				OtherCalls += 1
			end

			NumberValue.Changed:Connect(OnChanged)
			NumberValue.Changed:Connect(OnOtherChanged)

			const Connections = GetConnections(NumberValue.Changed)

			assert(typeof(Connections) == "table", `expected a table, got {typeof(Connections)}`)
			assert(#Connections == 2, `expected 2 connections in the table, got {#Connections}`)

			local Connection
			local OtherConnection

			for _, Entry in Connections do
				if Entry.Function == OnChanged then
					Connection = Entry
				elseif Entry.Function == OnOtherChanged then
					OtherConnection = Entry
				end
			end

			assert(Connection and OtherConnection, ".Function isn't the function that was connected")
			assert(Connection.Fire, "expected method 'Fire' in the table")

			Connection:Fire(GeneratedValue)

			assert(WaitFor(function()
				return DidChange
			end, 1), if WrongValue ~= nil then `the connection was fired with the wrong value, expected number '{GeneratedValue}' and got {typeof(WrongValue)} '{WrongValue}'` else "the connection wasn't fired")
			Formatters.CheckEqual(OtherCalls, 0, "the number of times the other connection ran when only one was fired")

			assert(typeof(Connection.Thread) == "thread", `.Thread should be a thread, got {typeof(Connection.Thread)}`)

			for Field, Type in {
				Enabled = "boolean",
				ForeignState = "boolean",
				LuaConnection = "boolean",
				Function = "function",
				Fire = "function",
				Defer = "function",
				Disconnect = "function",
				Disable = "function",
				Enable = "function",
			} do
				const Success, Value = pcall(function()
					return Connection[Field]
				end)

				assert(Success and type(Value) == Type, `.{Field} should be a {Type}, got {if Success then type(Value) else "an error"}`)
			end
			assert(Connection.Enabled == true, ".Enabled should be true for an active connection")

			DidChange = false
			Connection:Defer(GeneratedValue)

			assert(WaitFor(function()
				return DidChange
			end, 1), "the connection wasn't fired by :Defer()")

			Connection:Disable()

			assert(Connection.Enabled == false, ".Enabled should be false after :Disable()")
			assert(OtherConnection.Enabled == true, "disabling one connection also disabled the other one on the same signal")

			const CallsBeforeDisabled = Calls
			const OtherCallsBeforeDisabled = OtherCalls

			NumberValue.Value = GeneratedValue + 1

			assert(WaitFor(function()
				return OtherCalls > OtherCallsBeforeDisabled
			end, 1), "the other connection on the signal stopped firing after one was disabled")
			assert(Calls == CallsBeforeDisabled, "the connection still fired after :Disable()")

			Connection:Enable()

			assert(Connection.Enabled == true, ".Enabled should be true after :Enable()")

			NumberValue.Value = GeneratedValue + 2

			assert(WaitFor(function()
				return Calls > CallsBeforeDisabled
			end, 1), "the connection didn't fire again after :Enable()")

			Connection:Disconnect()

			const OtherCallsBeforeDisconnect = OtherCalls

			DidChange = false
			NumberValue.Value = GeneratedValue

			assert(WaitFor(function()
				return OtherCalls > OtherCallsBeforeDisconnect
			end, 1), "the other connection on the signal stopped firing after one was disconnected")
			assert(not DidChange, "the connection still fired after :Disconnect()")

			const Remaining = GetConnections(NumberValue.Changed)

			assert(#Remaining == 1, "the connection is still listed after :Disconnect()")
			assert(Remaining[1].Function == OnOtherChanged, "the connection left after :Disconnect() isn't the other one")

			const OnceConnection = NumberValue.Changed:Once(function() end)

			Formatters.CheckEqual(#GetConnections(NumberValue.Changed), 2, "the number of connections after connecting with :Once()")
			OnceConnection:Disconnect()
		end,
	},

	getscripts = {
		Test = function()
			const Scripts = getscripts()
			const SeenScripts = {}

			assert(table.find(Scripts, GetPlayerModule()), "didn't find PlayerModule")

			for _, Child in GetPlayerScripts():GetChildren() do
				if not Child:IsA("LocalScript") or not Child.Enabled then
					continue
				end

				assert(table.find(Scripts, Child), `didn't find {Child.Name}, a LocalScript that's running`)
			end

			for _, CurrentScript: BaseScript | ModuleScript in Scripts do
				assert(typeof(CurrentScript) == "Instance", `expected an instance, got {typeof(CurrentScript)} '{CurrentScript}'`)
				assert(
					CurrentScript:IsA("BaseScript") or CurrentScript:IsA("ModuleScript"),
					`instance '{CurrentScript}' isn't a script, its ClassName is {CurrentScript.ClassName}`
				)
				assert(not SeenScripts[CurrentScript], `'{CurrentScript}' is in the returned table more than once`)

				SeenScripts[CurrentScript] = true
			end
		end,
		ReturnType = "table",
	},

	setfpscap = {
		Test = function()
			const SetFPSCap: (FPSCap: number) -> () = setfpscap
			const GetFPSCap: (() -> number)? = getfpscap

			const function MeasureFPS(): number
				const StartTime = os.clock()

				local Frames = 0

				repeat
					task.wait()
					Frames += 1
				until os.clock() - StartTime >= 1

				return Frames / (os.clock() - StartTime)
			end

			const PreviousSuccess, PreviousCap = pcall(GetFPSCap or function()
				return 0
			end)
			const FPSCap = math.max(math.floor(MeasureFPS() / 4), 5)

			AddCleanup(function()
				SetFPSCap(if PreviousSuccess and typeof(PreviousCap) == "number" then PreviousCap else 0)
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
			Formatters.CheckEqual(
				base64encode(AllBytes),
				buffer.tostring(EncodingService:Base64Encode(buffer.fromstring(AllBytes))),
				"every byte from 0 to 255 encoded"
			)
			Formatters.CheckEqual(base64encode(""), "", "an empty string encoded")
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
			assert(loadstring("return game")() == game, "the loaded code can't see the game global")

			const WithEnvironment = loadstring("return DebuncValue")

			setfenv(WithEnvironment, {DebuncValue = 5})

			Formatters.CheckEqual(WithEnvironment(), 5, "a value read after setfenv")

			const Modern, ModernError = loadstring([[
				--!strict
				type Pair<T> = {First: T, Second: T}
				local Total = 0
				for Index = 1, 4 do
					if Index == 2 then
						continue
					end
					Total += Index // 1
				end
				return if Total > 0 then `total {Total}` else ""
			]])

			assert(Modern, `current Luau syntax failed to compile with '{ModernError}'`)
			Formatters.CheckEqual(Modern(), "total 8", "the result of current Luau syntax")
		end,
	},

	getfpscap = {
		Test = function()
			const GetFPSCap: () -> number = getfpscap
			const SetFPSCap: (FPSCap: number) -> () = Formatters.CheckExist("setfpscap")
			const PreviousCap = GetFPSCap()
			const RandomCap = math.random(11, 59)

			AddCleanup(function()
				SetFPSCap(if typeof(PreviousCap) == "number" then PreviousCap else 0)
			end)

			SetFPSCap(10)

			const Result = GetFPSCap()

			SetFPSCap(RandomCap)

			const RandomResult = GetFPSCap()

			SetFPSCap(0)

			Formatters.CheckEqual(Result, 10, "the fps cap")
			Formatters.CheckEqual(RandomResult, RandomCap, "the fps cap after setting it again")
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

			Formatters.CheckEqual(select("#", newcclosure(function(...)
				return ...
			end)(1, nil, nil)), 3, "the number of values passed through with trailing nils")

			if identifyexecutor and identifyexecutor() == "Delta" and not shared.CrashTests then
				error("catching an error thrown after a yield crashes Roblox on Delta, so it wasn't run, use shared.CrashTests = true to try it")
			end

			const ErrorObject = {}
			const Success, Caught = pcall(newcclosure(function()
				task.wait()
				error(ErrorObject)
			end))

			assert(not Success and Caught == ErrorObject, "an error object thrown after a yield didn't come back unchanged")
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

			local RootPart

			if not WaitFor(function()
				RootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
				return RootPart ~= nil
			end, 10) then
				error({Skipped = "your character or its HumanoidRootPart didn't load within 10 seconds", Environment = true})
			end

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

			const Touched = WaitFor(function()
				return Complete
			end, 5)
			const EndedEarly = Ended

			FireTouchInterest(Pad, RootPart, 1)

			const TouchEnded = WaitFor(function()
				return Ended
			end, 5)

			Pad:Destroy()

			assert(Touched, "failed to fire the touched event within 5 seconds")
			assert(not EndedEarly, "firing with 0 also fired TouchEnded, it should only fire Touched")
			assert(TouchEnded, "failed to fire the touch ended event within 5 seconds")
		end,
	},

	getoriginalenv = {
		Test = function()
			const GetOriginalEnv = getoriginalenv
			const HookFunction = Formatters.CheckExist("hookfunction")
			const HookMetamethod = Formatters.CheckExist("hookmetamethod")
			const Genv = getgenv()
			const Environment = GetOriginalEnv()

			Formatters.CheckReturnType(Environment, "table")

			const Missing = {}

			for _, Name in {"loadstring", "getgenv", "hookfunction", "hookmetamethod", "isfunctionhooked", "identifyexecutor", "game", "workspace", "print", "task", "string", "table", "debug"} do
				if rawget(Environment, Name) == nil and Environment[Name] == nil then
					table.insert(Missing, Name)
				end
			end

			assert(#Missing == 0, `the original env is missing {table.concat(Missing, ", ")}`)
			assert(
				not pcall(function()
					Environment.debUNC = true
				end)
					and not pcall(function()
						Environment.identifyexecutor = function() end
					end)
					and not pcall(function()
						Environment.string.rep = function() end
					end),
				"the returned table allows values in it to be changed, it needs to be frozen"
			)

			const function TryHook(Target: Function): boolean
				local Original
				const Success = pcall(function()
					Original = HookFunction(Target, function(...)
						return Original(...)
					end)
				end)

				if Success and Original then
					pcall(HookFunction, Target, Original)
				end

				return Success
			end

			assert(not TryHook(GetOriginalEnv) and not TryHook(Environment.identifyexecutor), "getoriginalenv or a function in it could be hooked")

			const Replaced = pcall(function()
				Genv.getoriginalenv = function() end
			end) and Genv.getoriginalenv ~= GetOriginalEnv

			if Replaced then
				rawset(Genv, "getoriginalenv", GetOriginalEnv)
			end

			assert(not Replaced, "getoriginalenv could be replaced in getgenv()")

			const IdentifyExecutor = Genv.identifyexecutor
			const RealName = IdentifyExecutor()
			local IdentifyOriginal
			local IdentifyRestored = false

			AddCleanup(function()
				if not IdentifyRestored and IdentifyOriginal then
					HookFunction(IdentifyExecutor, IdentifyOriginal)
				end

				Genv.identifyexecutor = IdentifyExecutor
			end)

			IdentifyOriginal = HookFunction(IdentifyExecutor, function()
				return "debUNC"
			end)

			const ControlName = IdentifyExecutor()
			const HookedName = Environment.identifyexecutor()
			const FreshHookedName = GetOriginalEnv().identifyexecutor()
			const Detected = Environment.isfunctionhooked(IdentifyExecutor)

			HookFunction(IdentifyExecutor, IdentifyOriginal)
			IdentifyRestored = true

			Genv.identifyexecutor = function()
				return "debUNC"
			end

			const ReplacedName = GetOriginalEnv().identifyexecutor()

			Genv.identifyexecutor = IdentifyExecutor

			const Rep = string.rep
			local RepOriginal
			local RepRestored = false

			AddCleanup(function()
				if not RepRestored and RepOriginal then
					HookFunction(Rep, RepOriginal)
				end
			end)

			RepOriginal = HookFunction(Rep, function()
				return "debUNC"
			end)

			const ControlRep = Rep("a", 2)
			const RepResult = Environment.string.rep("a", 2)

			HookFunction(Rep, RepOriginal)
			RepRestored = true

			if ControlName ~= "debUNC" or ControlRep ~= "debUNC" then
				error({Skipped = "hookfunction didn't change identifyexecutor or string.rep, so it can't check the original env against a hook"})
			end

			assert(HookedName == RealName and FreshHookedName == RealName, "getoriginalenv().identifyexecutor ran the hooked version instead of the original")
			assert(ReplacedName == RealName, "getoriginalenv().identifyexecutor ran the replaced version instead of the original")
			assert(Detected == true, "getoriginalenv().isfunctionhooked didn't see that identifyexecutor was hooked")
			assert(RepResult == "aa", "getoriginalenv().string.rep ran the hooked version instead of the original")

			const OriginalGame = GetOriginalEnv(game)
			local NamecallRuns, IndexRuns, GetServiceRuns = 0, 0, 0
			local NamecallOriginal, IndexOriginal, GetServiceOriginal
			const Restored = {}
			const GetService = game.GetService

			const function Unhook()
				if NamecallOriginal and not Restored.Namecall then
					Restored.Namecall = true
					pcall(HookMetamethod, game, "__namecall", NamecallOriginal)
				end

				if IndexOriginal and not Restored.Index then
					Restored.Index = true
					pcall(HookMetamethod, game, "__index", IndexOriginal)
				end

				if GetServiceOriginal and not Restored.GetService then
					Restored.GetService = true
					pcall(HookFunction, GetService, GetServiceOriginal)
				end
			end

			AddCleanup(Unhook)

			NamecallOriginal = HookMetamethod(game, "__namecall", function(...)
				NamecallRuns += 1

				return NamecallOriginal(...)
			end)

			IndexOriginal = HookMetamethod(game, "__index", function(...)
				IndexRuns += 1

				return IndexOriginal(...)
			end)

			game:GetService("Workspace")
			workspace:GetChildren()

			const ControlNamecallRuns = NamecallRuns

			pcall(function()
				return game.Name
			end)

			const ControlIndexRuns = IndexRuns

			NamecallRuns, IndexRuns = 0, 0

			const ServiceSuccess, Service = pcall(function()
				return OriginalGame:GetService("Workspace")
			end)
			const ServiceNamecallRuns = NamecallRuns
			const NameSuccess, Name = pcall(function()
				return OriginalGame.Name
			end)
			const NameIndexRuns = IndexRuns
			const OriginalWorkspace = select(2, pcall(function()
				return OriginalGame.Workspace
			end))
			const NamecallRunsBeforeChild = NamecallRuns

			pcall(function()
				OriginalWorkspace:GetChildren()
			end)

			const ChildNamecallRuns = NamecallRuns - NamecallRunsBeforeChild

			Unhook()

			GetServiceOriginal = HookFunction(GetService, function(...)
				GetServiceRuns += 1

				return GetServiceOriginal(...)
			end)

			game:GetService("Workspace")

			const ControlGetServiceRuns = GetServiceRuns

			pcall(function()
				return OriginalGame:GetService("Workspace")
			end)

			const OriginalGetServiceRuns = GetServiceRuns - ControlGetServiceRuns

			Unhook()

			const MetatableTarget = setmetatable({}, {__index = function()
				return "debUNC Original"
			end})
			const MetatableOriginal = HookMetamethod(MetatableTarget, "__index", function()
				return "debUNC Hooked"
			end)
			const MetatableControl = MetatableTarget.debUNC
			const MetatableSuccess, MetatableResult = pcall(function()
				return GetOriginalEnv(MetatableTarget).debUNC
			end)

			HookMetamethod(MetatableTarget, "__index", MetatableOriginal)

			if ControlNamecallRuns == 0 or ControlIndexRuns == 0 or MetatableControl ~= "debUNC Hooked" then
				error({Skipped = "hookmetamethod didn't catch calls on game or the test table, so it can't check the hooks being skipped"})
			end

			assert(ServiceSuccess and Service == workspace, `getoriginalenv(game):GetService("Workspace") should return workspace, got '{Service}'`)
			assert(ServiceNamecallRuns == 0, "calling a method on getoriginalenv(game) ran the __namecall hook")
			assert(NameSuccess and Name == game.Name and NameIndexRuns == 0, "reading a property on getoriginalenv(game) ran the hooked __index")
			assert(typeof(OriginalWorkspace) == "Instance", `getoriginalenv(game).Workspace should give an Instance, got {typeof(OriginalWorkspace)}`)
			assert(ChildNamecallRuns == 0, "when calling a method on an indexed object in getoriginalenv(game) it ran the hooked __namecall")
			assert(ControlGetServiceRuns == 0 or OriginalGetServiceRuns == 0, "getoriginalenv(game):GetService ran the hooked GetService instead of the original")
			assert(MetatableSuccess and MetatableResult == "debUNC Original", "calling getoriginalenv with a metatable arg returned the hooked metamethods")
			assert(not pcall(GetOriginalEnv, 1), "should error when passing an arg value that isn't an object or table")
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

			const CheckCaller = Formatters.CheckExist("checkcaller")
			const GetNamecallMethod = Formatters.CheckExist("getnamecallmethod")

			local Seen = 0
			local Restored = false
			local GameOriginal

			GameOriginal = HookMetamethod(game, "__namecall", (newcclosure or function(Function)
				return Function
			end)(function(Self, ...)
				if CheckCaller() and Self == game and GetNamecallMethod() == "GetService" then
					Seen += 1
				end

				return GameOriginal(Self, ...)
			end))

			AddCleanup(function()
				if not Restored then
					HookMetamethod(game, "__namecall", GameOriginal)
				end
			end)

			const Service = game:GetService("Workspace")

			HookMetamethod(game, "__namecall", GameOriginal)
			Restored = true

			assert(Seen > 0, "hooking game's __namecall didn't catch a game:GetService call")
			assert(Service == workspace, "game:GetService gave the wrong result while __namecall was hooked")

			const function Capture(Metamethod: string): Function
				local Captured

				xpcall(function()
					if Metamethod == "__index" then
						return (game :: any)[{}]
					end

					return (game :: any):debUNCMissingMethod()
				end, function()
					Captured = debug.info(2, "f")
				end)

				return Captured
			end

			const function Outcome(Function: Function, ...): string
				const Success, Result = pcall(Function, ...)

				return if Success then "succeeded" else tostring(Result)
			end

			const CapturedIndex = Capture("__index")
			const CapturedNamecall = Capture("__namecall")

			assert(typeof(CapturedIndex) == "function" and typeof(CapturedNamecall) == "function", "couldn't capture the game's __index and __namecall the way game scripts do")
			const BadCalls = {
				{Name = "__index with a string as self", Call = function() return Outcome(CapturedIndex, "debUNC", "Name") end},
				{Name = "__index with a table as the key", Call = function() return Outcome(CapturedIndex, game, {}) end},
				{Name = "__index with no arguments", Call = function() return Outcome(CapturedIndex) end},
				{Name = "__namecall with no arguments", Call = function() return Outcome(CapturedNamecall) end},
				{Name = "__namecall with a string as self", Call = function() return Outcome(CapturedNamecall, "debUNC") end},
			}

			local HookCalls = 0

			const function RunBadCalls()
				const Outcomes = {}
				const HookCallsBefore = HookCalls

				for Index, BadCall in BadCalls do
					Outcomes[Index] = BadCall.Call()
				end

				return Outcomes, HookCalls - HookCallsBefore
			end

			const Before = RunOnGameThread(RunBadCalls)

			local IndexOriginal, NamecallOriginal
			local Restored = false

			const function Unhook()
				if Restored then
					return
				end

				Restored = true

				if IndexOriginal then
					pcall(HookMetamethod, game, "__index", IndexOriginal)
				end

				if NamecallOriginal then
					pcall(HookMetamethod, game, "__namecall", NamecallOriginal)
				end
			end

			AddCleanup(Unhook)

			IndexOriginal = HookMetamethod(game, "__index", function(...)
				HookCalls += 1

				return IndexOriginal(...)
			end)

			NamecallOriginal = HookMetamethod(game, "__namecall", function(...)
				HookCalls += 1

				return NamecallOriginal(...)
			end)

			const After, HookCallsFromBadCalls = RunOnGameThread(RunBadCalls)

			Unhook()

			for Index, BadCall in BadCalls do
				assert(After[Index] == Before[Index], `calling the game's {BadCall.Name} gave "{After[Index]}" once it was hooked instead of "{Before[Index]}", so game scripts can detect the hook`)
			end

			assert(HookCallsFromBadCalls == 0, `the hook ran for bad calls that should have errored before reaching it ({HookCallsFromBadCalls} times)`)

			local StackOriginal
			local StackRestored = false
			const HookEnvironment = setmetatable({}, {__index = getfenv()})
			const function StackHook(...)
				return StackOriginal(...)
			end

			setfenv(StackHook, HookEnvironment)
			StackOriginal = HookMetamethod(game, "__namecall", StackHook)
			AddCleanup(function()
				if not StackRestored then
					HookMetamethod(game, "__namecall", StackOriginal)
				end
			end)

			local FoundOnStack = false

			xpcall(function()
				return (game :: any):debUNCMissingMethod()
			end, function()
				for Level = 1, 50 do
					const Function = debug.info(Level, "f")

					if not Function then
						break
					end

					if Function == StackHook or getfenv(Function) == HookEnvironment then
						FoundOnStack = true
					end
				end
			end)

			const YieldSuccess, YieldResult = pcall(function()
				return workspace:WaitForChild(`debUNC{math.random(1, 1e6)}`, 0.1)
			end)

			HookMetamethod(game, "__namecall", StackOriginal)
			StackRestored = true

			assert(not FoundOnStack, "the __namecall hook could be found on the stack from an error handler, so game scripts can detect it")
			assert(YieldSuccess and YieldResult == nil, `WaitForChild couldn't yield through the hooked __namecall, got "{YieldResult}"`)
		end,
		RunLast = true,
	},

	["debug.info"] = {
		Test = function()
			assert(typeof(debug.info) == "function", "scripts get a debug library without info, so any script using debug.info breaks")
			Formatters.CheckEqual(debug.info(print, "s"), "[C]", "the source of print")

			const function GetCaller(): any
				return debug.info(2, "f")
			end

			const function DebuncNamedFunction(First: any, Second: any, ...: any): {any}
				return {
					debug.info(1, "f"),
					GetCaller(),
					debug.info(1, "l"),
					debug.info(1, "l"),
					select("#", debug.info(1000, "f")),
				}
			end

			const Results = DebuncNamedFunction()

			assert(Results[1] == DebuncNamedFunction, "level 1 with 'f' didn't give the function that was running")
			assert(Results[2] == DebuncNamedFunction, "level 2 with 'f' didn't give the function that called the running one")
			assert(typeof(Results[3]) == "number" and Results[4] == Results[3] + 1, `two calls with 'l' on back to back lines should be 1 line apart, got {Results[3]} and {Results[4]}`)
			Formatters.CheckEqual(Results[5], 0, "the number of values for a level past the top of the stack")
			Formatters.CheckEqual(debug.info(DebuncNamedFunction, "n"), "DebuncNamedFunction", "the name of a named local function")

			const Arity, IsVariadic = debug.info(DebuncNamedFunction, "a")

			Formatters.CheckEqual(Arity, 2, "the number of parameters with 'a'")
			Formatters.CheckEqual(IsVariadic, true, "whether the function is variadic with 'a'")

			const Source = debug.info(DebuncNamedFunction, "s")

			assert(typeof(Source) == "string" and Source ~= "[C]", `the source of a Lua function should be its script, got '{Source}'`)
			Formatters.CheckEqual(Source, debug.info(1, "s"), "the source of a function from the same script as this test")

			const Combined = table.pack(debug.info(DebuncNamedFunction, "na"))
			const Reversed = table.pack(debug.info(DebuncNamedFunction, "an"))

			assert(
				Combined.n == 3 and Combined[1] == "DebuncNamedFunction" and Combined[2] == 2 and Combined[3] == true,
				`'na' should give the name then the arity, got {Combined[1]}, {Combined[2]}, {Combined[3]}`
			)
			assert(
				Reversed.n == 3 and Reversed[1] == 2 and Reversed[2] == true and Reversed[3] == "DebuncNamedFunction",
				`'an' should give the arity then the name, got {Reversed[1]}, {Reversed[2]}, {Reversed[3]}`
			)
		end,
	},

	setstackhidden = {
		Test = function()
			const SetStackHidden = setstackhidden
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

			if not HiddenCaller("traceback"):find("HiddenCaller", 1, true) or select(2, pcall(HiddenCaller, "error")) == "debUNC" then
				error({Skipped = "tracebacks and errors don't show the function even before it's hidden, so it can't check hiding it"})
			end

			SetStackHidden(HiddenCaller, true)

			assert(not table.find(HiddenCaller("frames"), HiddenCaller), "debug.info still found the function on the stack after it was hidden")
			assert(not HiddenCaller("traceback"):find("HiddenCaller", 1, true), "debug.traceback still shows the function after it was hidden")
			Formatters.CheckEqual(select(2, pcall(HiddenCaller, "error")), "debUNC", "the error from a hidden function, which shouldn't have its location")

			SetStackHidden(HiddenCaller, false)

			assert(table.find(HiddenCaller("frames"), HiddenCaller), "the function stayed hidden after setting it back to false")
		end,
	},

	isstackhidden = {
		Test = function()
			const IsStackHidden = isstackhidden
			const SetStackHidden = Formatters.CheckExist("setstackhidden")

			const function Target()
				return "debUNC Target"
			end

			const function Other()
				return "debUNC Other"
			end

			AddCleanup(function()
				SetStackHidden(Target, false)
			end)

			Formatters.CheckEqual(IsStackHidden(Target), false, "the result for a function that isn't hidden")

			SetStackHidden(Target, true)

			Formatters.CheckEqual(IsStackHidden(Target), true, "the result after hiding the function")
			Formatters.CheckEqual(IsStackHidden(Other), false, "the result for a different function that was never hidden")

			SetStackHidden(Target, false)

			Formatters.CheckEqual(IsStackHidden(Target), false, "the result after showing the function again")
		end,
	},

	["DirectoryWatcher.new"] = {
		Test = function()
			const CrashTests = shared.CrashTests

			if identifyexecutor and identifyexecutor() == "Synapse Z" and not CrashTests then
				error("this crashes Roblox on Synapse Z, so it wasn't run, use shared.CrashTests = true to try it")
			end

			const WriteFile = Formatters.CheckExist("writefile")
			const FolderName = `Folder_{math.random()}`
			const OtherFolderName = `Folder_{math.random()}`
			const FileName = `File_{math.random()}.txt`
			const OtherFileName = `File_{math.random()}.txt`
			const Changed = {}

			Formatters.CheckExist("makefolder")(FolderName)
			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			makefolder(OtherFolderName)
			AddCleanup(function()
				RemovePath("delfolder", OtherFolderName)
			end)

			const function WaitForSettled()
				local LastCount = #Changed
				local LastChange = os.clock()

				WaitFor(function()
					if #Changed ~= LastCount then
						LastCount = #Changed
						LastChange = os.clock()
					end

					return os.clock() - LastChange >= 0.5
				end, 3)
			end

			const Watcher = DirectoryWatcher.new(FolderName)

			AddCleanup(function()
				Watcher:Destroy()
			end)

			Watcher.OnChanged:Connect(function(Path)
				table.insert(Changed, tostring(Path))
			end)

			WriteFile(`{OtherFolderName}/{OtherFileName}`, "debUNC")
			WriteFile(`{FolderName}/{FileName}`, "debUNC")

			const Detected = WaitFor(function()
				return #Changed > 0
			end, 2)

			WaitForSettled()

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

			WaitForSettled()

			assert(Detected, "OnChanged didn't fire after a file in the folder was written")
			assert(table.concat(Changed, " "):find(FileName, 1, true), `OnChanged didn't give the changed file's path, got '{table.concat(Changed, ", ")}'`)
			assert(not table.concat(Changed, " "):find(OtherFileName, 1, true), "OnChanged fired for a file in a different folder")
			assert(ControlFired, "a second watcher on the same folder didn't fire, so it can't check it stopping after Destroy")
			Formatters.CheckEqual(#Changed, Count, "the number of changes after Destroy")
		end,
	},

	["WebSocket.connect"] = {
		Test = function()
			const Connected, Socket = pcall(WebSocket.connect, "wss://echo.websocket.org")

			if not Connected then
				error({Skipped = `couldn't connect to the echo server, got {Socket}`, Environment = true})
			end

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

			AddCleanup(function()
				Container:Destroy()
			end)

			const Part = Instance.new("Part", Container)

			if not rawequal(Part, Container:FindFirstChild("Part")) then
				error({Skipped = "looking up the part gave a new ref even before invalidating, so it can't check invalidating"})
			end

			cache.invalidate(Container:FindFirstChild("Part"))

			const NewReference = Container:FindFirstChild("Part")

			assert(not rawequal(Part, NewReference), "the reference to the part couldn't be invalidated")

			Part.Name = "debUNC"

			assert(NewReference and NewReference.Name == "debUNC", "the new ref doesn't point to the same part as the old ref")
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

			AddCleanup(function()
				Folder:Destroy()
			end)

			const Part = Instance.new("Part") :: Instance
			const Fire = Instance.new("Fire") :: Instance

			AddCleanup(function()
				Fire:Destroy()
			end)

			Part.Parent = Folder

			cache.replace(Part, Fire)

			assert(Folder:FindFirstChildWhichIsA("Instance") == Fire, "looking up the part still gave back the part instead of the fire")
			assert(Fire.Parent == nil, "the fire was moved into the folder instead of replacing the part's ref")
			Formatters.CheckEqual(#Folder:GetChildren(), 1, "the number of children in the folder")
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

			ClonedReference.Name = "debUNC"

			assert(Part.Name == "debUNC", "changing the .Name property on the cloned ref didn't change it on the original")
			assert(ClonedReference.ClassName == "Part" and ClonedReference:IsA("BasePart"), "the cloned ref's inherited class doesn't match the original Part")

			const Child = Instance.new("Folder")

			Child.Parent = Part

			assert(ClonedReference:FindFirstChild("Folder") == Child, "FindFirstChild on the cloned reference didn't find the original's child")

			local Changed = false

			ClonedReference.Changed:Connect(function()
				Changed = true
			end)

			Part.Transparency = 0.5

			assert(WaitFor(function()
				return Changed
			end, 1), "the cloned ref's .Changed event didn't fire when changing a property on the original ref")

			const Players = game:GetService("Players")

			assert(cloneref(Players).LocalPlayer == Players.LocalPlayer, "when trying to get the LocalPlayer from a cloned Players service, it didn't give the same as the original")
			assert(not pcall(cloneref, {}) and not pcall(cloneref, "debUNC"), "should error when passing an arg value that isn't an Instance")

			ClonedReference:Destroy()

			assert(not pcall(function()
				Part.Parent = workspace
			end), "destroying the cloned ref didn't destroy the original")
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

			local SpawnedResult

			task.spawn(function()
				SpawnedResult = CheckCaller()
			end)

			Formatters.CheckEqual(SpawnedResult, true, "the result inside of task.spawn from the executor")

			task.wait()

			Formatters.CheckEqual(CheckCaller(), true, "the result after task.wait")

			const PcallSuccess, PcallResult = pcall(function()
				return CheckCaller()
			end)

			assert(PcallSuccess and PcallResult == true, `should return true inside of pcall, got {PcallResult}`)

			assert(RunOnGameThread(CheckCaller) == false, "should return false when called by the ControlModule")
		end,
	},

	isfunctionhooked = {
		Test = function()
			const IsFunctionHooked: ((...any?) -> ...any?) -> boolean = isfunctionhooked
			const RestoreFunction = Formatters.CheckExist("restorefunction")

			const function Test()
				return "debUNC Original"
			end

			const function Other()
				return "debUNC Other"
			end

			assert(IsFunctionHooked(Test) == false, "an unhooked function should return false")

			AddCleanup(function()
				if IsFunctionHooked(Test) then
					RestoreFunction(Test)
				end
			end)

			Formatters.CheckExist("hookfunction")(Test, function()
				return "debUNC Hooked"
			end)

			assert(IsFunctionHooked(Test) == true, "a hooked function should return true")
			assert(IsFunctionHooked(Other) == false, "a function that was never hooked returned true after a different one was hooked")

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
			assert(base64decode(buffer.tostring(EncodingService:Base64Encode(buffer.fromstring(AllBytes)))) == AllBytes, "decoding every byte from 0 to 255 didn't give them all back unchanged")
			Formatters.CheckEqual(base64decode(""), "", "an empty string decoded")
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

			const LockedTable = setmetatable({}, {__metatable = "locked"})
			const NewMetatable = {__index = function()
				return "debUNC"
			end}

			assert(not pcall(setmetatable, LockedTable, NewMetatable), "setmetatable worked on a table with a locked metatable, so the lock didn't work")

			setrawmetatable(LockedTable, NewMetatable)

			assert(getmetatable(LockedTable) == NewMetatable, "a table with a locked metatable didn't get the new one")
			Formatters.CheckEqual(LockedTable.debUNC, "debUNC", "indexing a table after replacing its locked metatable")
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
			assert(lz4decompress(Formatters.CheckExist("lz4compress")(AllBytes), #AllBytes) == AllBytes, "every byte from 0 to 255 didn't survive compressing and decompressing")
		end,
	},

	["debug.getproto"] = {
		Test = function()
			const function Outer()
				const function Inner()
					return "debUNC"
				end

				const function Second()
					return "debUNC Second"
				end
			end

			const Proto = debug.getproto(Outer, 1)
			const SecondProto = debug.getproto(Outer, 2)
			const GetInfo = Formatters.CheckExist("debug.info")

			assert(type(Proto) == "function" or type(Proto) == "userdata" or type(Proto) == "table", `expected a function for the first inner function, got {typeof(Proto)}`)
			assert(type(SecondProto) == "function" or type(SecondProto) == "userdata" or type(SecondProto) == "table", `expected a function for the second inner function, got {typeof(SecondProto)}`)

			if typeof(Proto) ~= "function" then
				return
			end

			Formatters.CheckEqual(GetInfo(Proto, "n"), "Inner", "the name of the inner function")
			Formatters.CheckEqual(GetInfo(SecondProto, "n"), "Second", "the name of the second inner function")
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
				assert(type(Protos[Index]) == "function" or type(Protos[Index]) == "userdata" or type(Protos[Index]) == "table", `entry {Index} should be a function, got {typeof(Protos[Index])}`)

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

			local Outside = Method

			task.spawn(function()
				const Success, Result = pcall(GetNamecallMethod)

				Outside = if Success then Result else nil
			end)

			Formatters.CheckEqual(Outside, nil, "the namecall method on a new thread that never made a namecall")
		end,
	},

	getcallingscript = {
		Test = function()
			const PlayerModule = GetPlayerModule()
			const ControlModule = PlayerModule:FindFirstChild("ControlModule")
			const BaseCharacterController = ControlModule and ControlModule:FindFirstChild("BaseCharacterController")

			if not BaseCharacterController then
				error({Skipped = "this game has no ControlModule with a BaseCharacterController", Environment = true})
			end

			const Success, Controller = pcall(require, BaseCharacterController)

			assert(Success, "your executor needs to support 'require' to run this test")

			const GetMoveVectorOriginal = Controller.GetMoveVector
			local CallingScript
			local Called = false

			AddCleanup(function()
				Controller.GetMoveVector = GetMoveVectorOriginal
			end)

			Controller.GetMoveVector = function(...)
				Controller.GetMoveVector = GetMoveVectorOriginal
				Called = true
				CallingScript = getcallingscript()
				return GetMoveVectorOriginal(...)
			end

			if not WaitFor(function()
				return Called
			end, 2) then
				Controller.GetMoveVector = GetMoveVectorOriginal
				error({Skipped = "the ControlModule never called the hooked function", Environment = true})
			end

			assert(CallingScript, "returned nil when it should've returned a script")
			assert(typeof(CallingScript) == "Instance" and CallingScript:IsA("LuaSourceContainer"), `should return a script, got '{CallingScript}'`)
			assert(
				CallingScript:IsDescendantOf(PlayerModule),
				`the calling script of BaseCharacterController.GetMoveVector should be inside of PlayerModule, got '{CallingScript}'`
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
				if not Descendant:IsA("BasePart") or Descendant:IsA("Terrain") or not Descendant.Anchored or Descendant:IsDescendantOf(RootPart.Parent :: Instance) or Descendant:IsDescendantOf(workspace.CurrentCamera) then
					continue
				end

				assert(IsNetworkOwner(Descendant) == false, `should return false on '{Descendant:GetFullName()}', an anchored part the server owns`)
				return
			end

			error({Skipped = "there's no anchored part in workspace to check", Environment = true})
		end,
	},

	replicatesignal = {
		Test = function()
			const ReplicateSignal = replicatesignal

			assert(not pcall(ReplicateSignal, workspace.ChildAdded), "should error on a signal that can't be replicated")

			const RootPart = GetRootPart()

			const Character = RootPart.Parent :: Model
			const Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

			if not Humanoid then
				error({Skipped = "your character has no Humanoid", Environment = true})
			end

			local Died = false

			Humanoid.Died:Once(function()
				Died = true
			end)

			ReplicateSignal(Player.Kill)

			assert(WaitFor(function()
				return Died
			end, 5), "you weren't killed within 5 seconds after replicating Player.Kill")

			const Players = game:GetService("Players")
			const Respawned = WaitFor(function()
				const NewCharacter = Player.Character

				return NewCharacter ~= nil and NewCharacter ~= Character and NewCharacter:FindFirstChild("HumanoidRootPart") ~= nil
			end, Players.RespawnTime + 10)

			if not Players.CharacterAutoLoads and not Respawned then
				error({Skipped = "this game doesn't respawn characters, so it can't check if the server saw the kill", Environment = true})
			end

			assert(Respawned, "your character died but never respawned, so the kill only happened on your side instead of the server")
		end,
		RunLast = true,
	},

	["game.HttpPost"] = {
		Test = function()
			const Marker = `debUNC {math.random(1, 1e9)}`
			const Success, Result = pcall(game.HttpPost, game, "https://httpbin.org/post", Marker, "text/plain")

			CheckServerAvailable(Success, Result)
			Formatters.CheckReturnType(Result, "string")

			const DecodeSuccess, Decoded = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), Result)

			assert(DecodeSuccess, `httpbin didn't answer with its JSON echo, so the request may not have gone out as a POST, got '{Result:sub(1, 80)}'`)
			Formatters.CheckEqual(Decoded.data, Marker, "the body httpbin got")
			assert(tostring(Decoded.headers["Content-Type"]):find("text/plain", 1, true), `the content type wasn't sent, httpbin got '{Decoded.headers["Content-Type"]}'`)
		end,
		Retry = true,
	},

	["game.HttpGet"] = {
		Test = function()
			const MissingSuccess, MissingResult = pcall(game.HttpGet, game, "https://awqbcduwendewbnzd.aaaaaa")

			assert(
				not MissingSuccess or not MissingResult or MissingResult == "",
				"game:HttpGet on a website that doesn't exist should return an error, nil, or an empty string"
			)

			const function Get(Url: string, ...: any): string
				const Success, Response = pcall(game.HttpGet, game, Url, ...)

				CheckServerAvailable(Success, Response)

				return Response
			end

			const Marker = tostring(math.random(1, 1e9))
			const DecodeSuccess, Decoded = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), Get(`https://httpbin.org/get?debunc={Marker}`))

			assert(DecodeSuccess, "the response wasn't the JSON httpbin sends back")
			assert(Decoded.args and Decoded.args.debunc == Marker, "the query that was sent didn't come back, so the request may not have really gone out")

			local Cached = false

			for _, Page in {
				{Kind = "JSON", Url = `https://httpbin.org/uuid?debunc={math.random(1, 1e9)}`},
				{Kind = "HTML", Url = `https://www.random.org/integers/?num=1&min=1&max=1000000000&col=1&base=10&format=html&rnd=new&debunc={math.random(1, 1e9)}`},
				{Kind = "plain text", Url = `https://www.random.org/integers/?num=1&min=1&max=1000000000&col=1&base=10&format=plain&rnd=new&debunc={math.random(1, 1e9)}`},
			} do
				const First = Get(Page.Url)
				const Second = Get(Page.Url)
				const NoCacheSuccess, Fresh = pcall(game.HttpGet, game, Page.Url, true)

				assert(NoCacheSuccess, `passing true for NoCache errored with {Fresh}`)
				CheckServerAvailable(NoCacheSuccess, Fresh)
				assert(typeof(Fresh) == "string" and #Fresh > 0, `passing true for NoCache didn't return the {Page.Kind} response`)
				assert(Get(Page.Url, true) ~= Fresh, `two {Page.Kind} requests with NoCache set to true gave the same cached response, so true may be treated as cache instead of no cache`)

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
					supQ = "1.0.0",
				})[Name],
				`the version '{ExecutorVersion}' never changes between updates, it should be the real version of each release`
			)
		end,
	},

	gethwid = {
		Test = function()
			const GetHardwareId = gethwid
			const HardwareId = GetHardwareId()

			assert(typeof(HardwareId) == "string", "the returned value (user's hwid/fingerprint) should be a string")
			assert(HardwareId ~= "", "the hwid is empty")
			assert(GetHardwareId() == HardwareId, "calling it twice gave different hwids")

			const Success, Result = pcall(Formatters.CheckExist("request"), {
				Url = "https://httpbin.org/get",
				Method = "GET",
			})

			if not Success or typeof(Result) ~= "table" or Result.StatusCode == 429 or typeof(Result.StatusCode) == "number" and Result.StatusCode >= 500 then
				error({Skipped = "couldn't get a response from httpbin to compare the hwid with", Environment = true})
			end

			const Decoded, Response = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), Result.Body)

			if not Decoded or typeof(Response) ~= "table" or typeof(Response.headers) ~= "table" then
				error({Skipped = "httpbin didn't send back the headers as JSON", Environment = true})
			end

			const Header = FindFingerprintHeader(Response.headers)

			if not Header then
				error({Skipped = "request didn't send a fingerprint header to compare the hwid with"})
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
			assert(getmetatable(Detector) == FakeMetatable, "getmetatable stopped returning the locked __metatable value")

			const StringMetatable = GetRawMetatable("")

			assert(typeof(StringMetatable) == "table" and StringMetatable.__index == string, "didn't return the string metatable")
			assert(typeof(GetRawMetatable(Vector3.zero)) == "table", "didn't return a Vector3's metatable")
			assert(GetRawMetatable({}) == nil, "returned a metatable for a table that doesn't have one")

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

			const Plain = {}

			SetReadOnly(Plain, true)

			assert(not pcall(function()
				Plain.debUNC = true
			end), "a normal table could still be written to after making it read-only")

			const GameMetatable = Formatters.CheckExist("getrawmetatable")(game)

			AddCleanup(function()
				SetReadOnly(GameMetatable, true)
			end)

			SetReadOnly(GameMetatable, false)

			const GameUnlocked = not table.isfrozen(GameMetatable)

			SetReadOnly(GameMetatable, true)

			assert(GameUnlocked, "game's metatable stayed read-only after unlocking it")
			assert(table.isfrozen(GameMetatable), "game's metatable didn't become read-only again")
		end,
	},

	getsenv = {
		Test = function()
			const GetScriptEnvironment: (Script: LocalScript) -> any = getsenv
			const SoundsScript = GetPlayerScripts():FindFirstChild("RbxCharacterSounds")
			const Value = math.random()

			if not SoundsScript then
				error({Skipped = "this game has no RbxCharacterSounds script to copy", Environment = true})
			end

			const function CreateNewModuleTest(SetParent: boolean)
				const New = SoundsScript:Clone()

				AddCleanup(function()
					New:Destroy()
				end)

				const AtomicBinding = New:FindFirstChildWhichIsA("ModuleScript")

				if not AtomicBinding then
					error({Skipped = "the copied RbxCharacterSounds has no AtomicBinding ModuleScript", Environment = true})
				end

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
			assert(NilParentEnvironment.script == NewSoundsNilScript, ".script doesn't point to the script when its parent was nil")
		end,
	},

	decompile = {
		Test = function()
			const Decompile = decompile
			const CameraModule = GetPlayerModule().CameraModule
			const Result = Decompile(CameraModule)

			Formatters.CheckReturnType(Result, "string")

			assert(not Result:find("\0", 1, true), "the result has null bytes, so it isn't readable code")
			assert(Result:find("__index"), `couldn't find '__index' in the decompiled 'CameraModule', it started with '{Result:sub(1, 300)}'`)
			assert(Decompile(CameraModule.Parent.ControlModule) ~= Result, "'CameraModule' and 'ControlModule' decompiled to the same thing")

			for _, Constant in Formatters.CheckExist("debug.getconstants")(Formatters.CheckExist("getscriptclosure")(CameraModule)) do
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
				Scale.X > 0 and math.abs(Scale.X - Scale.Y) < Scale.X * 0.05,
				`the mouse went to {First} then {Second}, which doesn't match moving to {FirstTarget} then {SecondTarget}`
			)

			const Expected = First + (LastTarget - FirstTarget) * Scale.X
			const Last = MoveTo(LastTarget)

			assert((Last - Expected).Magnitude < 4, `the mouse went to {Last} instead of {Expected}`)
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
				FirstMove.X > 0 and math.abs(FirstMove.X - FirstMove.Y) < 4 and (SecondMove - FirstMove * 2).Magnitude < 6,
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

			const function GetScrollDirections(Delta: number): {number}
				const Directions = {}

				local LastScroll = os.clock()

				const Connection = UserInputService.InputChanged:Connect(function(Input)
					if typeof(Input) ~= "Instance" or not Input:IsA("InputObject") or Input.UserInputType ~= Enum.UserInputType.MouseWheel then
						return
					end

					table.insert(Directions, Input.Position.Z)
					LastScroll = os.clock()
				end)

				AddCleanup(function()
					Connection:Disconnect()
				end)

				mousescroll(Delta)

				WaitFor(function()
					return #Directions > 0 and os.clock() - LastScroll >= 0.25
				end, 1.5)

				Connection:Disconnect()

				return Directions
			end

			const UpDirections = GetScrollDirections(120)
			const DownDirections = GetScrollDirections(-120)

			assert(#UpDirections > 0, "the scroll up wasn't detected")
			assert(#DownDirections > 0, "the scroll down wasn't detected")

			for _, Direction in UpDirections do
				assert(Direction > 0, "scrolling up also fired a wheel event that scrolled down")
			end

			for _, Direction in DownDirections do
				assert(Direction < 0, "scrolling down also fired a wheel event that scrolled up")
			end
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

			const Connection = LogService.MessageOut:Connect(function(Message)
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
				error({Skipped = "printidentity's output never showed up in the log"})
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

			local Inherited
			local AfterYield

			task.spawn(function()
				SetThreadIdentity(2)
				task.spawn(function()
					Inherited = Formatters.CheckExist("getthreadidentity")()
				end)
				task.wait()
				AfterYield = Formatters.CheckExist("getthreadidentity")()
			end)

			const MainIdentity = Formatters.CheckExist("getthreadidentity")()

			WaitFor(function()
				return AfterYield ~= nil
			end, 2)

			SetThreadIdentity(Original)

			const function CanUseRobloxScript()
				return pcall(function()
					return game:GetService("CorePackages").Name
				end)
			end

			const function CanUseRobloxSecurity()
				return pcall(function()
					return Instance.new("SurfaceAppearance").TexturePack
				end)
			end

			local Capabilities

			task.spawn(function()
				SetThreadIdentity(2)

				const RobloxScriptAtTwo, RobloxSecurityAtTwo = CanUseRobloxScript(), CanUseRobloxSecurity()

				SetThreadIdentity(8)
				Capabilities = {RobloxScriptAtTwo, RobloxSecurityAtTwo, CanUseRobloxScript(), CanUseRobloxSecurity()}
			end)

			WaitFor(function()
				return Capabilities ~= nil
			end, 2)

			local StringIdentity
			const GetThreadIdentity = Formatters.CheckExist("getthreadidentity")

			task.spawn(function()
				const Success = pcall(SetThreadIdentity, "debUNC")

				StringIdentity = {Success, GetThreadIdentity()}
			end)

			WaitFor(function()
				return StringIdentity ~= nil
			end, 2)

			assert(not ReadAtTwo, "CoreGui could still be read at identity 2")
			assert(ReadAtEight, "CoreGui couldn't be read at identity 8")
			assert(Capabilities, "a thread that changed its identity never finished")
			assert(not Capabilities[1] and not Capabilities[2], "a thread at identity 2 could still use RobloxScript or RobloxSecurity members, so the identity only changed in name")
			assert(Capabilities[3] and Capabilities[4], "a thread at identity 8 couldn't use RobloxScript or RobloxSecurity members")
			assert(StringIdentity, "a thread that tried setting a string identity never finished")
			assert(not StringIdentity[1], "should error when given something that isn't a number")
			Formatters.CheckEqual(StringIdentity[2], Original, "the identity after trying to set it to a string")
			Formatters.CheckEqual(MainIdentity, 8, "this thread's identity after another thread changed its own")
			Formatters.CheckEqual(Inherited, 2, "the identity of a thread started from an identity 2 thread")
			Formatters.CheckEqual(AfterYield, 2, "the identity after a yield")
		end,
	},

	restorefunction = {
		Test = function()
			const HookFunction = Formatters.CheckExist("hookfunction")
			const GetInfo = Formatters.CheckExist("debug.info")
			const NewCClosure = newcclosure
			const Frexp = math.frexp
			const FrexpError = select(2, pcall(Frexp, "debUNC"))

			AddCleanup(function()
				pcall(restorefunction, Frexp)
			end)

			const Targets = {
				{Name = "a LuaClosure", Expected = "debUNC Original", Create = function()
					return function()
						return "debUNC Original"
					end
				end},
				{Name = "a C function", Expected = 0.5, Create = function()
					return Frexp
				end},
			}
			const Hooks = {
				{Name = "a LuaClosure", Expected = "debUNC Hooked", Hook = function()
					return "debUNC Hooked"
				end},
				{Name = "a C function", Expected = 1, Hook = math.sign},
			}

			if NewCClosure then
				table.insert(Targets, {Name = "a NewCClosure", Expected = "debUNC Original", Create = function()
					return NewCClosure(function()
						return "debUNC Original"
					end)
				end})
				table.insert(Hooks, {Name = "a NewCClosure", Expected = "debUNC Hooked", Hook = NewCClosure(function()
					return "debUNC Hooked"
				end)})
			end

			for _, Target in Targets do
				for _, Hook in Hooks do
					const Function = Target.Create()
					const Source = GetInfo(Function, "s")
					const Pair = `{Target.Name} hooked with {Hook.Name}`

					HookFunction(Function, Hook.Hook)

					const HookedResult = Function(8)

					restorefunction(Function)

					assert(HookedResult == Hook.Expected, `hookfunction didn't hook {Pair}, can't check restoring it`)
					Formatters.CheckEqual(Function(8), Target.Expected, `the result of {Pair} after restoring it`)
					Formatters.CheckEqual(GetInfo(Function, "s"), Source, `the source of {Pair} after restoring it`)
				end
			end

			Formatters.CheckEqual(select(2, pcall(Frexp, "debUNC")), FrexpError, "math.frexp's error after hooking and restoring it")

			const function Again()
				return "debUNC Original"
			end

			for Round = 1, 2 do
				HookFunction(Again, function()
					return "debUNC Hooked"
				end)

				const Hooked = Again() == "debUNC Hooked"

				restorefunction(Again)

				assert(Hooked, `hooking a restored function again didn't work on round {Round}`)
			end

			assert(Again() == "debUNC Original", "hooking and restoring the same function twice didn't bring back the original")

			const function First()
				return "debUNC First"
			end

			const function Second()
				return "debUNC Second"
			end

			for _, Function in {First, Second} do
				HookFunction(Function, function()
					return "debUNC Hooked"
				end)
			end

			restorefunction(First)

			const SecondStillHooked = Second() == "debUNC Hooked"

			restorefunction(Second)

			Formatters.CheckEqual(First(), "debUNC First", "the restored function's result")
			assert(SecondStillHooked, "restoring one function also restored a different one")

			const function Stacked()
				return "debUNC Original"
			end

			for Layer = 1, 2 do
				Formatters.CheckExist("hookfunction")(Stacked, function()
					return `debUNC Hook {Layer}`
				end)
			end

			restorefunction(Stacked)

			assert(Stacked() == "debUNC Original", "restoring a function that was hooked twice didn't bring back the original")

			const function OriginalIndex()
				return "debUNC Original"
			end

			const Proxy = newproxy(true)

			getmetatable(Proxy).__index = OriginalIndex
			Formatters.CheckExist("hookmetamethod")(Proxy, "__index", function()
				return "debUNC Hooked"
			end)

			assert(Proxy.debUNC == "debUNC Hooked", "hookmetamethod didn't hook __index, can't check restoring it")

			restorefunction(OriginalIndex)

			Formatters.CheckEqual(Proxy.debUNC, "debUNC Original", "a hooked __index after restoring its original function")
			assert(not pcall(restorefunction, 1), "restoring something that isn't a function should error")
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

			for Algorithm, Expected in {
				md5 = "900150983cd24fb0d6963f7d28e17f72",
				sha1 = "a9993e364706816aba3e25717850c26c9cd0d89d",
				sha384 = "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7",
				sha512 = "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
			} do
				const Success, Result = pcall(Hash, "abc", Algorithm)

				assert(Success and typeof(Result) == "string" and Result:lower() == Expected, `the {Algorithm} hash of 'abc' was wrong, got {Result}`)
			end

			Formatters.CheckEqual(Hash("", "sha256"):lower(), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "the sha256 hash of an empty string")

			const MadeUpSuccess, MadeUpResult = pcall(Hash, "abc", "debunc")

			assert(not MadeUpSuccess or MadeUpResult == nil, `hashing with an algorithm that doesn't exist gave '{MadeUpResult}' instead of erroring`)

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
			const SeenKeys = {}
			const SeenBytes = {}

			local DifferentBytes = 0

			for _ = 1, 32 do
				const Key = crypt.generatekey()
				const Decoded = buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(Key)))

				assert(#Decoded == 32, "the decoded key should be 32 bytes")
				assert(not SeenKeys[Key], "generated the same key twice")
				assert(Decoded ~= string.rep(Decoded:sub(1, 1), 32), "generated a key that's the same byte over and over")

				SeenKeys[Key] = true

				for _, Byte in {string.byte(Decoded, 1, -1)} do
					if SeenBytes[Byte] then
						continue
					end

					SeenBytes[Byte] = true
					DifferentBytes += 1
				end
			end

			assert(DifferentBytes > 64, `32 keys only used {DifferentBytes} different byte values, so they aren't random`)
		end,
	},

	["crypt.generatebytes"] = {
		Test = function()
			const SeenResults = {}
			const SeenBytes = {}

			local DifferentBytes = 0

			for _ = 1, 32 do
				const Length = math.random(8, 64)
				const Decoded = buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(crypt.generatebytes(Length))))

				assert(#Decoded == Length, `the decoded bytes should be {Length} long`)
				assert(not SeenResults[Decoded], "generated the same bytes twice")
				assert(Decoded ~= string.rep(Decoded:sub(1, 1), Length), `generated {Length} bytes that are all the same byte`)

				SeenResults[Decoded] = true

				for _, Byte in {string.byte(Decoded, 1, -1)} do
					if SeenBytes[Byte] then
						continue
					end

					SeenBytes[Byte] = true
					DifferentBytes += 1
				end
			end

			assert(DifferentBytes > 64, `32 calls only used {DifferentBytes} different byte values, so they aren't random`)
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

			for _, RoundTripText in {"", CreateRandomString(16)} do
				const Success, RoundTripEncrypted, RoundTripVector = pcall(Crypt.encrypt, RoundTripText, Key)

				assert(Success, `encrypting {#RoundTripText} bytes errored with {RoundTripEncrypted}`)
				assert(Crypt.decrypt(RoundTripEncrypted, Key, RoundTripVector) == RoundTripText, `decrypting {#RoundTripText} bytes didn't give back the original text`)
			end

			const function DecodeBase64(Encoded: string): string
				return buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(Encoded)))
			end

			const Plain = DecodeBase64("a8G+4i5An5bpPX4Rc5MXKg==")
			const VectorKey = "YD3rEBXKcb4rc67whX13gR81LAc7YQjXLZgQowkU3/Q="
			const Success, Result = pcall(Crypt.encrypt, Plain, VectorKey, "8PHy8/T19vf4+fr7/P3+/w==", "CTR")

			assert(Success, `encrypting in CTR mode errored with {Result}`)
			Formatters.CheckEqual(Result, "YB7DE3dXiaW3p/UEu/PSKA==", "the published AES-256 CTR test vector")

			const CipherBlockSuccess, CipherBlockResult = pcall(Crypt.encrypt, Plain, VectorKey, "AAECAwQFBgcICQoLDA0ODw==", "CBC")

			assert(CipherBlockSuccess, `encrypting in CBC mode errored with {CipherBlockResult}`)
			assert(DecodeBase64(CipherBlockResult):sub(1, 16) == DecodeBase64("9YxMBNbl8bp3nqv7X3v71g=="), `encrypting in CBC mode gave {CipherBlockResult}, which doesn't match the AES-256 CBC test vector`)
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

			for _, Type in {"Line", "Text", "Image", "Circle", "Square", "Quad", "Triangle"} do
				const Object = Drawing.new(Type)
				const StartedVisible = Object.Visible

				Object:Remove()

				Formatters.CheckEqual(StartedVisible, false, `a new {Type}'s Visible`)
			end

			const Decimal = Drawing.new("Line")

			Decimal.Thickness = 2.5
			Decimal.Transparency = 0.25

			const KeptThickness = Decimal.Thickness
			const KeptTransparency = Decimal.Transparency

			Decimal:Remove()

			Formatters.CheckEqual(KeptThickness, 2.5, "Thickness after setting it to 2.5")
			Formatters.CheckEqual(KeptTransparency, 0.25, "Transparency after setting it to 0.25")
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
			const DrawingNew = Formatters.CheckExist("Drawing.new")
			const Drawings = {}

			for _, Type in {"Line", "Square", "Text"} do
				const Object = DrawingNew(Type)

				AddCleanup(function()
					Object:Remove()
				end)

				Drawings[Type] = Object
			end

			cleardrawcache()

			for Type, Object in Drawings do
				assert(Object.__OBJECT_EXISTS == false, `the {Type} drawing object still exists`)
			end

			const NewLine = DrawingNew("Line")

			AddCleanup(function()
				NewLine:Remove()
			end)

			assert(NewLine.__OBJECT_EXISTS == true, "Drawing.new stopped making working objects after the cache was cleared")
		end,
	},

	runonthread = {
		Test = function()
			AddCleanup(function()
				shared.debUNCThread = nil
			end)

			const function GetRanThread(Thread: thread): thread?
				shared.debUNCThread = nil

				runonthread(Thread, "shared.debUNCThread = coroutine.running()")

				WaitFor(function()
					return shared.debUNCThread ~= nil
				end, 1)

				const RanThread = shared.debUNCThread

				shared.debUNCThread = nil

				return RanThread
			end

			const Thread = task.spawn(function()
				task.wait(2)
			end)

			AddCleanup(function()
				task.cancel(Thread)
			end)

			const SpawnedRanThread = GetRanThread(Thread)

			task.cancel(Thread)

			assert(SpawnedRanThread ~= nil, "the code didn't run on the thread")
			assert(SpawnedRanThread ~= coroutine.running(), "the code ran on the thread that called runonthread instead of the one it was given")

			const Coroutine = coroutine.create(function()
				coroutine.yield()
			end)

			AddCleanup(function()
				coroutine.close(Coroutine)
			end)

			coroutine.resume(Coroutine)

			const CoroutineRanThread = GetRanThread(Coroutine)

			coroutine.close(Coroutine)

			assert(CoroutineRanThread ~= nil, "the code didn't run on a thread made with coroutine.create")
			assert(CoroutineRanThread ~= coroutine.running(), "the code ran on the thread that called runonthread instead of the coroutine.create thread it was given")
		end,
	},

	runonactor = {
		Test = function()
			const Value = math.random()
			const Argument = `debUNC {math.random()}`

			const Ran, Attributes = pcall(RunOnNewActor, `Actor:SetAttribute("Value", {Value}) Actor:SetAttribute("Argument", (select(2, ...))) Actor:SetAttribute("HasExecutor", typeof(getgenv) == "function" and typeof(hookfunction) == "function") Actor:SetAttribute("IsExecutor", checkcaller and checkcaller() == true) local Desynchronized = pcall(task.desynchronize) if Desynchronized then task.synchronize() end Actor:SetAttribute("OnActor", Desynchronized or (typeof(getactorfromthread) == "function" and getactorfromthread(coroutine.running()) == Actor))`, Argument)

			if not Ran then
				const Actor = Instance.new("Actor")

				Instance.new("LocalScript").Parent = Actor
				Actor.Parent = GetPlayerScripts()
				AddCleanup(function()
					Actor:Destroy()
				end)

				Formatters.CheckExist("runonactor")(Actor, `(...):SetAttribute("Done", true)`, Actor)

				assert(not WaitFor(function()
					return Actor:GetAttribute("Done") == true
				end, 2), "the executor failed to init a new actor, it only ran code on an actor that already had a script running")

				error(Attributes, 0)
			end

			assert(Attributes.Value == Value, "the code didn't run on the actor")
			assert(Attributes.OnActor == true, "the code didn't run on the actor's own thread")
			assert(Attributes.Argument == Argument, "the extra arg value passed to runonactor didn't reach the code")
			assert(Attributes.HasExecutor, "executor functions like getgenv and hookfunction aren't there inside the actor")
			assert(Attributes.IsExecutor, "checkcaller didn't return true for executor code running on the actor")
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
			const Actor = Instance.new("Actor")

			Actor.Parent = workspace
			AddCleanup(function()
				Actor:SetAttribute("Release", true)
				Actor:Destroy()
			end)

			Formatters.CheckExist("runonactor")(Actor, `local Actor = ... Actor:SetAttribute("Running", true) repeat task.wait() until Actor:GetAttribute("Release")`, Actor)

			const Started = WaitFor(function()
				return Actor:GetAttribute("Running") == true
			end, 2)

			const Threads = getactorthreads()

			Actor:SetAttribute("Release", true)

			if not Started then
				error({Skipped = "runonactor never started the code on the actor, so there's no running actor to look for"})
			end

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
			const Holder = {
				Table = {},
				Function = function() end,
			}
			const GarbageCollected = getgc(true)

			Formatters.CheckReturnType(GarbageCollected, "table")

			assert(table.find(GarbageCollected, Holder.Function), "didn't find a new function")
			assert(table.find(GarbageCollected, Holder.Table), "didn't find a new table when including tables")

			const WithoutTables = getgc(false)
			const Seen = {}

			for _, Value in WithoutTables do
				assert(type(Value) ~= "table", "returned a table even though tables weren't asked for")
				assert(not Seen[Value], "returned the same value twice")
				Seen[Value] = true
			end

			const Fired = {}
			const Proxy = newproxy(true)
			const Metatable = getmetatable(Proxy)

			for _, Metamethod in {"__index", "__newindex", "__tostring", "__len", "__unm", "__add", "__eq", "__lt", "__le", "__concat", "__call"} do
				Metatable[Metamethod] = function()
					table.insert(Fired, Metamethod)
				end
			end

			getgc(true)
			getgc(false)

			assert(#Fired == 0, `ran {table.concat(Fired, ", ")} on a userdata it collected, so game scripts can detect it with a trapped newproxy`)

			const Weak = setmetatable({}, {__mode = "v"})

			local Garbage = {}

			Weak[1] = Garbage

			const Held = getgc(true)
			const InSnapshot = table.find(Held, Garbage) ~= nil

			Garbage = nil

			assert(InSnapshot, "the held result didn't have a new table in it, so it can't check it keeping garbage alive")

			WaitFor(function()
				for _ = 1, 2000 do
					table.create(64, 0)
				end

				return Weak[1] == nil
			end, 6)

			const HeldMetatable = getrawmetatable and getrawmetatable(Held)

			assert(Weak[1] == nil, `kept garbage alive while its result was held, so game scripts can detect it with a weak table (__mode is {if HeldMetatable then tostring(HeldMetatable.__mode) else "not set"})`)
			const Counted, Info = collectgarbage("count"), gcinfo()

			assert(math.abs(Counted - Info) <= 64, `collectgarbage("count") said {Counted} but gcinfo() said {Info}, so one of them is being faked`)
		end,
	},

	getinstances = {
		Test = function()
			const Holder = {Part = Instance.new("Part")}

			AddCleanup(function()
				Holder.Part:Destroy()
			end)

			const ParentedPart = Instance.new("Part")

			ParentedPart.Parent = workspace
			AddCleanup(function()
				ParentedPart:Destroy()
			end)

			const Instances = getinstances()

			ParentedPart:Destroy()

			assert(table.find(Instances, Holder.Part), "didn't find a new part")
			assert(table.find(Instances, ParentedPart), "didn't find a part parented to workspace")
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

	isexecutorthread = {
		Test = function()
			const IsExecutorThread = isexecutorthread
			const Animate = Player.Character and Player.Character:FindFirstChild("Animate")

			if not Animate then
				error({Skipped = "your character or its Animate script isn't loaded", Environment = true})
			end

			const GameThread = Formatters.CheckExist("getscriptthread")(Animate)
			const SpawnedThread = task.spawn(function()
				coroutine.yield()
			end)

			AddCleanup(function()
				task.cancel(SpawnedThread)
			end)

			assert(IsExecutorThread(coroutine.running()) == true, "returned false for the thread running this test")
			assert(IsExecutorThread(SpawnedThread) == true, "returned false for a thread this test started")
			assert(GameThread, "couldn't find the Animate script's thread to test with")

			if coroutine.status(GameThread) == "dead" then
				error({Skipped = "the Animate script's thread already finished", Environment = true})
			end

			assert(IsExecutorThread(GameThread) == false, "returned true for a game script's thread")
			assert(not pcall(IsExecutorThread, 1), "should error when given something that isn't a thread")
		end,
	},

	["Regex.new"] = {
		Test = function()
			const Pattern = Regex.new("d(e+)b")
			const Match = Pattern:Match("xdeeeb deb")

			assert(typeof(Match) == "table" and typeof(Match.Captures) == "table", if typeof(Match) == "table" then "Match returned a table without a Captures field" else `Match should return a table with Captures, got {typeof(Match)}`)
			Formatters.CheckEqual(Match.Captures[1], "deeeb", "the whole match")
			Formatters.CheckEqual(Match.Captures[2], "eee", "the first capture group")
			Formatters.CheckEqual(Pattern:Match("xyz"), nil, "Match on text with no match")
			Formatters.CheckEqual(Pattern:Replace("deb deeb", "Z"), "Z Z", "Replace on text with two matches")

			const function GetCaptures(Expression: string, Text: string): {string}
				const Found = Regex.new(Expression):Match(Text)

				return if typeof(Found) == "table" and typeof(Found.Captures) == "table" then Found.Captures else {}
			end

			Formatters.CheckEqual(GetCaptures("cat|dog", "hotdog")[1], "dog", "the match for cat|dog in \"hotdog\"")
			Formatters.CheckEqual(GetCaptures("\\d{3}", "ab12345")[1], "123", "the match for \\d{3} in \"ab12345\"")
			Formatters.CheckEqual(GetCaptures("a.*?b", "aXbYb")[1], "aXb", "the non-greedy match for a.*?b in \"aXbYb\"")

			const Grouped = GetCaptures("(?:ab)+(c)", "xababc")

			Formatters.CheckEqual(Grouped[1], "ababc", "the whole match for (?:ab)+(c) in \"xababc\"")
			Formatters.CheckEqual(Grouped[2], "c", "the first capture group for (?:ab)+(c), since (?:ab) shouldn't capture")
			assert(not pcall(function()
				return Regex.new("(abc"):Match("abc")
			end), "should error when passing a pattern with an unclosed group")
		end,
	},

	["Regex.Escape"] = {
		Test = function()
			const RegexNew = Formatters.CheckExist("Regex.new")
			const Escaped = Regex.Escape("a.b*c")

			assert(RegexNew(Escaped):Match("a.b*c"), "the escaped pattern didn't match the text it was made from")
			assert(RegexNew(Escaped):Match("axb*c") == nil, `the escaped pattern '{Escaped}' still treats '.' as any character`)

			const Metacharacters = ".*+?^$()[]{}|\\"

			for Character in string.gmatch(Metacharacters, ".") do
				const EscapedCharacter = Regex.Escape(Character)
				const Success, Pattern = pcall(RegexNew, EscapedCharacter)

				assert(Success, `escaping '{Character}' gave '{EscapedCharacter}', which errored as a pattern`)

				const Found = Pattern:Match(`a{Character}b`)

				assert(Found and Found.Captures[1] == Character, `the escaped pattern '{EscapedCharacter}' didn't match '{Character}'`)
				assert(Pattern:Match("ab") == nil, `the escaped pattern '{EscapedCharacter}' matched text without '{Character}' in it`)
			end

			const AllEscaped = Regex.Escape(Metacharacters)
			const Found = RegexNew(AllEscaped):Match(`x{Metacharacters}x`)

			assert(Found and Found.Captures[1] == Metacharacters, `escaping every special character at once gave '{AllEscaped}', which didn't match the same text`)
			assert(RegexNew(AllEscaped):Match(Metacharacters:sub(2)) == nil, `the escaped pattern '{AllEscaped}' matched the text with its first character missing`)
		end,
	},

	getfflagtype = {
		Test = function()
			const GetFFlagType = getfflagtype

			Formatters.CheckEqual(GetFFlagType("DebugGraphicsPreferVulkan"), "bool", "the type of a true or false flag")
			Formatters.CheckEqual(GetFFlagType("TaskSchedulerTargetFps"), "int", "the type of a number flag")
		end,
	},

	getscriptbytecode = {
		Test = function()
			const GetScriptBytecode = getscriptbytecode
			const PlayerModule = GetPlayerModule()
			const Bytecode = GetScriptBytecode(PlayerModule)

			Formatters.CheckReturnType(Bytecode, "string")

			assert(#Bytecode > 0, "the bytecode is empty")
			assert(#Bytecode >= 64, `the bytecode is only {#Bytecode} bytes, which is too short for the PlayerModule`)
			assert(string.byte(Bytecode, 1) ~= 0, "the bytecode starts with a 0 byte, so it's a compile error instead of real bytecode")
			assert(GetScriptBytecode(PlayerModule) == Bytecode, "getting the same script's bytecode twice gave different results")
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

			assert(Hash == Formatters.CheckExist("crypt.hash")(Formatters.CheckExist("getscriptbytecode")(LocalScript), "sha384"), "the hash isn't the sha384 of the script's bytecode")
		end,
	},

	getscriptclosure = {
		Test = function()
			const LocalScript = GetPlayerScripts():FindFirstChildWhichIsA("LocalScript", true)
			const Closure = getscriptclosure(LocalScript)

			Formatters.CheckReturnType(Closure, "function")

			assert(getfenv(Closure).script == LocalScript, "the closure's script doesn't match")

			const CameraUtils = GetPlayerModule():FindFirstChild("CameraUtils", true)

			if not CameraUtils or not CameraUtils:IsA("ModuleScript") then
				error({Skipped = "the PlayerModule has no CameraUtils ModuleScript to compare with", Environment = true})
			end

			const Required, RequiredResult = pcall(require, CameraUtils)

			if not Required or typeof(RequiredResult) ~= "table" then
				error({Skipped = "requiring CameraUtils didn't return a table to compare with"})
			end

			const ModuleClosure = getscriptclosure(CameraUtils)

			Formatters.CheckReturnType(ModuleClosure, "function")

			const Called, CalledResult = pcall(ModuleClosure)

			assert(Called, `calling the ModuleScript's closure errored with {CalledResult}`)
			assert(typeof(CalledResult) == "table", `calling the ModuleScript's closure should return a table like require does, got {typeof(CalledResult)}`)

			for Key, Value in RequiredResult do
				assert(typeof(CalledResult[Key]) == typeof(Value), `the closure's returned table doesn't have the '{Key}' that require has`)
			end

			for Key in CalledResult do
				assert(RequiredResult[Key] ~= nil, `the closure's returned table has a '{Key}' that require doesn't have`)
			end
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
			assert(#Hash == 96 and Hash:match("^%x+$") ~= nil, `the hash should be SHA384 like the standard, got {#Hash} characters instead of 96`)

			const function MakeClosure(Value: number)
				return function()
					return Value
				end
			end

			assert(GetFunctionHash(MakeClosure(1)) == GetFunctionHash(MakeClosure(2)), "two functions with the same code but different upvalues gave different hashes, upvalues shouldn't be part of the hash")
		end,
	},

	isexecutorclosure = {
		Test = function()
			const IsExecutorClosure = isexecutorclosure

			assert(IsExecutorClosure(function() end) == true, "should return true for a function made in the executor")
			assert(IsExecutorClosure(print) == false, "should return false for print")
			assert(IsExecutorClosure(IsExecutorClosure) == true, "should return true for itself")

			assert(IsExecutorClosure(Formatters.CheckExist("newcclosure")(function() end)) == true, "should return true for a NewCClosure made in the executor")
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
			const GetFastFlag = getfflag
			const Value = GetFastFlag("MaxFrameBufferSize")

			Formatters.CheckReturnType(Value, "string")

			assert(Value ~= "", "the flag's value is empty")
			assert(tonumber(Value) ~= nil, `MaxFrameBufferSize is a number flag, got '{Value}'`)

			const Found, Missing = pcall(GetFastFlag, `debUNC{math.random(1, 1e6)}`)

			assert(not Found or Missing == nil, "returned a value for a flag that doesn't exist")

			for _, Flag in {
				"HandleAltEnterFullscreenManually",
				"DebugGraphicsPreferD3D11",
				"DebugGraphicsPreferVulkan",
			} do
				const Success, BooleanValue = pcall(GetFastFlag, Flag)

				if not Success or BooleanValue == nil then
					continue
				end

				assert(typeof(BooleanValue) == "string" and table.find({"true", "false"}, BooleanValue:lower()),`{Flag} is a true or false flag, got '{BooleanValue}'`)
				return
			end

			error({Skipped = "none of the true or false flags it checks exist in this roblox version", Environment = true})
		end,
	},

	setfflag = {
		Test = function()
			const GetFastFlag = Formatters.CheckExist("getfflag")
			const SetFastFlag = setfflag
			local Flag = "DebugGraphicsPreferD3D11"

			if not pcall(SetFastFlag, Flag, GetFastFlag(Flag)) then
				Flag = "TaskSchedulerTargetFps"
			end

			const Original = GetFastFlag(Flag)
			const NewValue = if Original:lower() == "true" then "false" elseif Original:lower() == "false" then "true" else tostring(math.random(100, 200))

			AddCleanup(function()
				SetFastFlag(Flag, Original)
			end)

			SetFastFlag(Flag, NewValue)

			const Result = GetFastFlag(Flag)

			SetFastFlag(Flag, Original)

			Formatters.CheckEqual(Result:lower(), NewValue, "the flag")
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
			const Packets = {}
			const Counts = {}

			const function OnSend(Packet)
				Packets[Packet.PacketId] = Packet.AsString
				Counts[Packet.PacketId] = (Counts[Packet.PacketId] or 0) + 1
			end

			AddCleanup(function()
				RakNet.removesendhook(OnSend)
			end)

			Formatters.CheckExist("raknet.addsendhook")(OnSend)
			task.wait(3)
			RakNet.removesendhook(OnSend)

			local CommonId

			for PacketId, Count in Counts do
				if CommonId and Counts[CommonId] >= Count then
					continue
				end

				CommonId = PacketId
			end

			if not CommonId then
				error({Skipped = "no packet was sent within 3 seconds to copy and send again"})
			end

			RakNet.send(Packets[CommonId])
			RakNet.send(buffer.fromstring(Packets[CommonId]))

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

			assert(typeof(CallStack[1].currentline) == "number", "the stack entry for the calling function doesn't have a currentline number")
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
			const WaitingThread = task.spawn(task.wait, 30)

			AddCleanup(function()
				task.cancel(WaitingThread)
			end)

			const Threads = getallthreads()

			task.cancel(WaitingThread)

			Formatters.CheckReturnType(Threads, "table")

			for _, Thread in Threads do
				assert(typeof(Thread) == "thread", `one of the returned values is a {typeof(Thread)} instead of a thread`)
			end

			assert(table.find(Threads, coroutine.running()), "didn't find the thread that's running this test")
			assert(table.find(Threads, WaitingThread), "didn't find a thread that was spawned and is waiting")
			assert(#Threads > 1, "only found the thread that's running this test")
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

				assert(Encrypted ~= Text, "encrypting gave back the same text, it needs to be changed")
				assert(Decrypted == Text, `decrypting {#Text} bytes of random text gave back {#Decrypted} bytes that don't match`)
			end

			const Text = CreateRandomString(math.random(1, 64))
			const Encrypted, InitializationVector = Encrypt(Text, Key)

			CheckWrongKey(Crypt, Encrypted, InitializationVector, Text)

			const Success, Result = pcall(Crypt.decrypt, "YB7DE3dXiaW3p/UEu/PSKA==", "YD3rEBXKcb4rc67whX13gR81LAc7YQjXLZgQowkU3/Q=", "8PHy8/T19vf4+fr7/P3+/w==", "CTR")

			assert(Success, `decrypting in CTR mode errored with {Result}`)
			Formatters.CheckEqual(
				Result,
				buffer.tostring(EncodingService:Base64Decode(buffer.fromstring("a8G+4i5An5bpPX4Rc5MXKg=="))),
				"the decrypted AES-256 CTR test vector"
			)
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
			const HookSignal = hooksignal
			const NumberValue = Instance.new("NumberValue")
			const SiblingValue = Instance.new("NumberValue")
			const AllowedValue = Instance.new("NumberValue")

			AddCleanup(function()
				NumberValue:Destroy()
				restoresignal(NumberValue.Changed)
			end)
			AddCleanup(function()
				SiblingValue:Destroy()
			end)
			AddCleanup(function()
				AllowedValue:Destroy()
				restoresignal(AllowedValue.Changed)
			end)

			local FiredCount = 0
			local SiblingCount = 0
			local AllowedCount = 0
			local HookArgument
			local HookValue

			const function OnChanged()
				FiredCount += 1
			end

			NumberValue.Changed:Connect(OnChanged)
			SiblingValue.Changed:Connect(function()
				SiblingCount += 1
			end)

			HookSignal(NumberValue.Changed, function(Info, Value)
				HookArgument = Info
				HookValue = Value
				return false
			end)

			NumberValue.Value = 1
			SiblingValue.Value = 1
			task.wait()
			task.wait()

			assert(HookArgument ~= nil, "the hook wasn't called when the signal fired")
			assert(FiredCount == 0, "returning false from the hook didn't stop the connection from firing")
			assert(typeof(HookArgument) == "table" and HookArgument.Function == OnChanged, "the Info given to the hook doesn't have the connected function")
			Formatters.CheckEqual(HookValue, 1, "the value the hook was given with the signal")
			Formatters.CheckEqual(SiblingCount, 1, "the number of times a different NumberValue's Changed fired while another one was hooked")

			AllowedValue.Changed:Connect(function()
				AllowedCount += 1
			end)

			HookSignal(AllowedValue.Changed, function()
				return true
			end)

			AllowedValue.Value = 1
			task.wait()
			task.wait()

			assert(AllowedCount == 1, "returning true from the hook stopped the connection from firing")
		end,
	},

	issignalhooked = {
		Test = function()
			const IsSignalHooked = issignalhooked
			const NumberValue = Instance.new("NumberValue")

			AddCleanup(function()
				NumberValue:Destroy()
				restoresignal(NumberValue.Changed)
			end)

			NumberValue.Changed:Connect(function() end)

			assert(IsSignalHooked(NumberValue.Changed) == false, "should return false before the signal is hooked")

			Formatters.CheckExist("hooksignal")(NumberValue.Changed, function() end)

			assert(IsSignalHooked(NumberValue.Changed) == true, "should return true after the signal is hooked")

			Formatters.CheckExist("restoresignal")(NumberValue.Changed)

			assert(IsSignalHooked(NumberValue.Changed) == false, "should return false after the signal is restored")
		end,
	},

	restoresignal = {
		Test = function()
			const NumberValue = Instance.new("NumberValue")

			AddCleanup(function()
				NumberValue:Destroy()
				restoresignal(NumberValue.Changed)
			end)

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
			task.wait()

			assert(HookCount == 1, "hooksignal didn't hook the signal, can't continue the test")

			restoresignal(NumberValue.Changed)

			const FiredBefore = FiredCount

			NumberValue.Value = 2
			task.wait()
			task.wait()

			assert(HookCount == 1, "the hook was still called after restoresignal")
			assert(FiredCount == FiredBefore + 1, "the connection didn't fire after restoresignal")
			assert(Formatters.CheckExist("issignalhooked")(NumberValue.Changed) == false, "issignalhooked still returned true after restoresignal")
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
			CheckInputFree(IsTestKey)

			const Detected = WaitForInput(UserInputService.InputBegan, IsTestKey, function()
				keyclick(0x7C)
			end)

			const Released = WaitFor(function()
				return not UserInputService:IsKeyDown(Enum.KeyCode.F13)
			end, 1)

			if not Released then
				Formatters.CheckExist("keyrelease")(0x7C)
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

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, `return {Value}`)

			const Loaded = CallAsync(loadfileasync, FileName)

			Formatters.CheckReturnType(Loaded, "function")
			Formatters.CheckEqual(Loaded(), Value, "the value the loaded file returned")
		end,
	},

	appendfileasync = {
		Test = function()
			const ReadFile = Formatters.CheckExist("readfile")
			const FileName = `File_{math.random()}.txt`
			const Appended = tostring(math.random())

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, "debUNC")

			CallAsync(appendfileasync, FileName, Appended)

			assert(WaitFor(function()
				return ReadFile(FileName) == `debUNC{Appended}`
			end, 2), "the text wasn't added to the end of the file within 2 seconds")
		end,
	},

	saveinstance = {
		Test = function()
			const PredictedMegabytes = #game:GetDescendants() * 10 / 1e6

			if PredictedMegabytes > 10 then
				error({Skipped = `the saved place would be about {math.floor(PredictedMegabytes)} MB, which is too large to test quickly`, Environment = true})
			end

			const ListFiles = listfiles
			const Before = {}

			for _, Path in if ListFiles then ListFiles("") else {} do
				Before[Path] = true
			end

			AddCleanup(function()
				for _, Path in if ListFiles then ListFiles("") else {} do
					if not Before[Path] and tostring(Path):lower():find("%.rbxlx?$") then
						RemovePath("delfile", Path)
					end
				end
			end)

			const Folder = Instance.new("Folder")
			const FolderName = `debUNCSaved{math.random(1, 1e9)}`

			Folder.Name = FolderName
			Folder.Parent = workspace
			AddCleanup(function()
				Folder:Destroy()
			end)

			const FileName = saveinstance({noscripts = true})

			Folder:Destroy()

			Formatters.CheckReturnType(FileName, "string")

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			const Exists = Formatters.CheckExist("isfile")(FileName)
			const Contents = if Exists then Formatters.CheckExist("readfile")(FileName) else ""

			assert(Exists, `the saved file '{FileName}' doesn't exist`)
			assert(#Contents > 1000, `the saved file is only {#Contents} bytes, so it can't have the place in it`)
			assert(Contents:sub(1, 7) == "<roblox", "the saved file doesn't start with <roblox, so it isn't a place file")
			assert(Contents:sub(1, 8) == "<roblox!" or Contents:find(FolderName, 1, true),"a folder that was added to workspace isn't in the saved file, so it didn't save the current game")
		end,
		RunLast = true,
	},

	getcustomasset = {
		Test = function()
			const FileName = `File_{math.random()}.png`

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, TestImage)

			const Success, AssetId = pcall(getcustomasset, FileName)

			if not Success then
				error(`errored while getting the asset with {AssetId}`)
			end

			Formatters.CheckReturnType(AssetId, "string")

			assert(AssetId:find("^rbxasset://"), `expected an rbxasset:// id, got '{AssetId}'`)
			Formatters.CheckEqual(GetAssetStatus(AssetId), Enum.AssetFetchStatus.Success, "the status of loading the asset")
		end,
	},

	getsignalarguments = {
		Test = function()
			const GetSignalArguments = getsignalarguments
			const Part = Instance.new("Part")

			AddCleanup(function()
				Part:Destroy()
			end)

			const Arguments = GetSignalArguments(Part.Touched)

			Formatters.CheckReturnType(Arguments, "table")
			Formatters.CheckEqual(#Arguments, 1, "the number of arguments Touched has")
			assert(Arguments[1] == "Instance" or Arguments[1] == "BasePart", `expected the type of Touched's argument to be Instance or BasePart, got {Arguments[1]}`)
			Formatters.CheckEqual(#GetSignalArguments(UserInputService.InputBegan), 2, "the number of arguments InputBegan has")

			const ChildAddedArguments = GetSignalArguments(workspace.ChildAdded)

			Formatters.CheckEqual(#ChildAddedArguments, 1, "the number of args ChildAdded has")
			Formatters.CheckEqual(ChildAddedArguments[1], "Instance", "the type of ChildAdded's arg")
			Formatters.CheckEqual(#GetSignalArguments(Part.Destroying), 0, "the number of args Destroying has")
		end,
	},

	getsignalargumentsinfo = {
		Test = function()
			const GetSignalArgumentsInfo = getsignalargumentsinfo
			const Part = Instance.new("Part")

			AddCleanup(function()
				Part:Destroy()
			end)

			const Info = GetSignalArgumentsInfo(Part.Touched)

			Formatters.CheckReturnType(Info, "table")

			assert(typeof(Info[1]) == "table", `expected a table for each argument, got {typeof(Info[1])}`)
			Formatters.CheckEqual(Info[1].Name, "otherPart", "the name of Touched's argument")
			assert(Info[1].Type == "Instance" or Info[1].Type == "BasePart", `expected the type of Touched's argument to be Instance or BasePart, got {Info[1].Type}`)

			const InputInfo = GetSignalArgumentsInfo(UserInputService.InputBegan)

			Formatters.CheckEqual(#InputInfo, 2, "the number of arguments InputBegan has")
			Formatters.CheckEqual(InputInfo[2].Name, "gameProcessedEvent", "the name of InputBegan's second argument")

			const ChildAddedInfo = GetSignalArgumentsInfo(workspace.ChildAdded)

			Formatters.CheckEqual(#ChildAddedInfo, 1, "the number of args ChildAdded has")
			assert(typeof(ChildAddedInfo[1]) == "table", `expected a table for ChildAdded's arg, got {typeof(ChildAddedInfo[1])}`)
			Formatters.CheckEqual(ChildAddedInfo[1].Type, "Instance", "the type of ChildAdded's arg")
			Formatters.CheckEqual(#GetSignalArgumentsInfo(Part.Destroying), 0, "the number of args Destroying has")
		end,
	},

	getsignalwhitelist = {
		Test = function()
			const Whitelist = getsignalwhitelist()

			Formatters.CheckReturnType(Whitelist, "table")

			assert(#Whitelist > 1, "the whitelist should have more than one signal")

			local FoundKill = false

			for _, Entry in Whitelist do
				assert(
					typeof(Entry) == "table" and typeof(Entry.Event) == "string" and typeof(Entry.Parent) == "string",
					"each entry should be a table with an Event and a Parent string"
				)
				assert(Entry.Event ~= "" and Entry.Parent ~= "", "an entry has an empty Event or Parent")

				FoundKill = FoundKill or (Entry.Parent == "Player" and Entry.Event == "Kill")
			end

			assert(FoundKill, "the whitelist doesn't have Player.Kill, which replicatesignal can always send")
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

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, Text)

			Formatters.CheckEqual(CallAsync(readfileasync, FileName), Text, "the text read from the file")
		end,
	},

	writefileasync = {
		Test = function()
			const ReadFile = Formatters.CheckExist("readfile")
			const FileName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			CallAsync(writefileasync, FileName, Text)

			assert(WaitFor(function()
				return pcall(ReadFile, FileName) and ReadFile(FileName) == Text
			end, 2), "the text wasn't written to the file within 2 seconds")
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
			const Success, Objects = pcall(getobjects, "rbxassetid://125013769")

			if not Success then
				const MarketplaceService = game:GetService("MarketplaceService")

				if not pcall(MarketplaceService.GetProductInfo, MarketplaceService, 125013769) then
					error({Skipped = "roblox's servers can't be reached to load the model", Environment = true})
				end

				error(`errored while loading the model with {Objects}`)
			end

			Formatters.CheckReturnType(Objects, "table")

			AddCleanup(function()
				for _, Object in Objects do
					if typeof(Object) == "Instance" then
						Object:Destroy()
					end
				end
			end)

			const Sword = Objects[1]

			assert(typeof(Sword) == "Instance", `expected an instance, got {typeof(Sword)}`)
			Formatters.CheckEqual(Sword.ClassName, "Tool", "the loaded model's class")
			Formatters.CheckEqual(Sword.Name, "LinkedSword", "the loaded model's name")
			assert(Sword.Parent == nil, "the loaded model shouldn't be parented to anything")
			assert(Sword:FindFirstChild("Handle") ~= nil, "the loaded model doesn't have the sword's Handle")
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

	queueonteleport = {
		OtherNames = {"queue_on_teleport", "queue_teleport", "queueteleport"},
		Test = function()
			if TeleportResults.Queued == nil then
				error({Skipped = "it needs a teleport, use shared.TeleportTests = true to try it", Environment = true})
			end

			assert(TeleportResults.Queued, "the queued code never ran after the last teleport")
		end,
	},

	clearqueueonteleport = {
		OtherNames = {"clear_teleport_queue", "clearteleportqueue"},
		Test = function()
			if TeleportResults.Cleared == nil then
				error({Skipped = "it needs a teleport, use shared.TeleportTests = true to try it", Environment = true})
			end

			assert(not TeleportResults.Cleared, "code queued before clearing still ran after the teleport")
		end,
	},

	["MessageBox.new"] = {
		Test = function()
			const NewMessageBox = MessageBox.new

			for _, Name in {
				"Error",
				"Question",
				"Warning",
				"Information",
			} do
				assert(typeof(MessageBox.Icons) == "table" and MessageBox.Icons[Name] ~= nil, `MessageBox.Icons is missing the {Name} preset`)
			end

			local TimeoutChoice
			local TimeoutReturned = false

			const TimeoutBox = NewMessageBox({
				Title = "debUNC",
				Text = "debUNC test, you can close this",
				Buttons = {"debUNC"},
				Duration = 1,
				Callback = function(Choice)
					TimeoutChoice = Choice
				end,
			})

			AddCleanup(function()
				pcall(TimeoutBox.Close, TimeoutBox)
			end)

			task.spawn(function()
				TimeoutBox:Show()
				TimeoutReturned = true
			end)

			const YieldedUntilChoice = WaitFor(function()
				return TimeoutReturned
			end, 4) and TimeoutChoice ~= nil

			WaitFor(function()
				return TimeoutChoice ~= nil
			end, 2)

			assert(TimeoutChoice == "TimedOut", `expected the Callback to get 'TimedOut' after the Duration ran out, got '{TimeoutChoice}'`)
			assert(YieldedUntilChoice, ":Show() didn't yield until a choice was made when Yield was true")

			local CloseChoice
			local CloseReturned = false

			const CloseBox = NewMessageBox({
				Title = "debUNC",
				Text = "debUNC test, you can close this",
				Buttons = {"debUNC"},
				Yield = false,
			})

			AddCleanup(function()
				pcall(CloseBox.Close, CloseBox)
			end)

			CloseBox:OnChoice(function(Choice)
				CloseChoice = Choice
			end)

			task.spawn(function()
				CloseBox:Show()
				CloseReturned = true
			end)

			const ReturnedRightAway = WaitFor(function()
				return CloseReturned
			end, 0.5)

			CloseBox:Close()

			WaitFor(function()
				return CloseChoice ~= nil
			end, 2)

			assert(ReturnedRightAway, ":Show() still yielded when Yield was false")
			assert(CloseChoice == "ForceClosed", `expected :Close() to give the OnChoice function 'ForceClosed', got '{CloseChoice}'`)
		end,
		RunLast = true,
	},

	getcallbackvalue = {
		Test = function()
			const GetCallbackValue = getcallbackvalue
			const BindableFunction = Instance.new("BindableFunction")

			const function OnInvoke()
				return "debUNC"
			end

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == nil, "should return nil when no callback is set")

			local Calls = 0

			BindableFunction.OnInvoke = function()
				Calls += 1
			end
			BindableFunction.OnInvoke = OnInvoke

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == OnInvoke, "didn't return the callback that was set")
			Formatters.CheckEqual(Calls, 0, "the number of times reading a replaced callback called it")

			BindableFunction.OnInvoke = nil

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == nil, "should return nil after the callback is cleared")

			const Wrapped = Formatters.CheckExist("newcclosure")(OnInvoke)

			BindableFunction.OnInvoke = Wrapped

			assert(GetCallbackValue(BindableFunction, "OnInvoke") == Wrapped, "didn't return a NewCClosure callback that was set")

			const RemoteFunction = Instance.new("RemoteFunction")

			RemoteFunction.OnClientInvoke = OnInvoke

			assert(GetCallbackValue(RemoteFunction, "OnClientInvoke") == OnInvoke, "didn't return a RemoteFunction's OnClientInvoke")

			const OnClose = function() end

			game.OnClose = OnClose

			const DataModelCallback = GetCallbackValue(game, "OnClose")

			game.OnClose = nil

			assert(DataModelCallback == OnClose, "didn't return game.OnClose, a callback on the DataModel")
			assert(not pcall(GetCallbackValue, BindableFunction, "Name"), "should error for a property that isn't a callback")
		end,
	},

	getfunctionbytecode = {
		Test = function()
			const GetFunctionBytecode = getfunctionbytecode

			const function First()
				return 1
			end

			const function Second()
				return "debUNCSecondFunctionConstant"
			end

			const Bytecode = GetFunctionBytecode(First)

			Formatters.CheckReturnType(Bytecode, "string")

			const SecondBytecode = GetFunctionBytecode(Second)

			assert(#Bytecode > 0, "the bytecode is empty")
			assert(GetFunctionBytecode(First) == Bytecode, "getting the same function's bytecode twice gave different results")
			assert(SecondBytecode ~= Bytecode, "two different functions gave the same bytecode")
			assert(SecondBytecode:find("debUNCSecondFunctionConstant", 1, true), "the bytecode doesn't have the function's string constant, so it isn't the function's real bytecode")
			assert(not Bytecode:find("debUNCSecondFunctionConstant", 1, true), "the bytecode has a string constant from a different function in it")
		end,
	},

	getobjectreferences = {
		Test = function()
			const Box = {Holder = {{}}}
			const Decoy = {{}}
			const References = getobjectreferences(Box.Holder[1])

			Formatters.CheckReturnType(References, "table")

			assert(table.find(References, Box.Holder), "didn't find the table holding the object")
			assert(not table.find(References, Decoy), "returned a table that doesn't hold the object")

			const WrongReference = FindWrongReference(Box.Holder[1], References)

			assert(WrongReference == nil, `returned a {typeof(WrongReference)} that doesn't reference the object`)
		end,
	},

	getfunctionreferences = {
		Test = function()
			const Box = {Holder = {function() end}}
			const Decoy = {function() end}
			const References = getfunctionreferences(Box.Holder[1])

			Formatters.CheckReturnType(References, "table")

			assert(table.find(References, Box.Holder), "didn't find the table holding the function")
			assert(not table.find(References, Decoy), "returned a table that doesn't hold the function")

			const WrongReference = FindWrongReference(Box.Holder[1], References)

			assert(WrongReference == nil, `returned a {typeof(WrongReference)} that doesn't reference the function`)
		end,
	},

	trampolinecall = {
		OtherNames = {"trampoline_call", "syn.trampoline_call"},
		Test = function()
			const TrampolineCall = FindFirstFunction("trampolinecall") or FindFirstFunction("trampoline_call") or FindFirstFunction("syn.trampoline_call")
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

			const GetIdentity = Formatters.CheckExist("getthreadidentity")
			const Identity = GetIdentity()
			const IdentitySuccess, NewIdentity = TrampolineCall(GetIdentity, {}, {identity = 2})

			assert(IdentitySuccess == true, `the identity option errored with {NewIdentity}`)
			Formatters.CheckEqual(NewIdentity, 2, "the identity inside of the call")
			Formatters.CheckEqual(GetIdentity(), Identity, "the identity after the call")

			const CheckCaller = Formatters.CheckExist("checkcaller")
			const GetCallingScript = Formatters.CheckExist("getcallingscript")
			const Character = Player.Character

			if not Character then
				error({Skipped = "your character isn't loaded, so it can't check the thread option", Environment = true})
			end

			const Animate = Character:FindFirstChild("Animate")

			if not Animate then
				error({Skipped = "your character has no Animate script, so it can't check the thread option", Environment = true})
			end

			const Thread = Formatters.CheckExist("getscriptthread")(Animate)

			if not Thread then
				error({Skipped = "the Animate script doesn't have a running thread, so it can't check the thread option"})
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

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, Text)

			Formatters.CheckEqual(getfilesize(FileName), #Text, "the size of the file")
		end,
	},

	renamefile = {
		Test = function()
			const IsFile = Formatters.CheckExist("isfile")
			const OldName = `File_{math.random()}.txt`
			const NewName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			AddCleanup(function()
				RemovePath("delfile", OldName)
			end)
			AddCleanup(function()
				RemovePath("delfile", NewName)
			end)

			Formatters.CheckExist("writefile")(OldName, Text)

			renamefile(OldName, NewName)

			assert(not IsFile(OldName), "the old file still exists")
			Formatters.CheckEqual(Formatters.CheckExist("readfile")(NewName), Text, "the renamed file's text")
		end,
	},

	movefile = {
		Test = function()
			const FolderName = `Folder_{math.random()}`
			const FileName = `File_{math.random()}.txt`
			const Text = tostring(math.random())

			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			Formatters.CheckExist("makefolder")(FolderName)

			AddCleanup(function()
				RemovePath("delfile", FileName)
			end)

			Formatters.CheckExist("writefile")(FileName, Text)

			movefile(FileName, `{FolderName}/{FileName}`)

			assert(not Formatters.CheckExist("isfile")(FileName), "the old file still exists")
			Formatters.CheckEqual(Formatters.CheckExist("readfile")(`{FolderName}/{FileName}`), Text, "the moved file's text")
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
	const Placeholder = newproxy()
	const MarketplaceService = game:GetService("MarketplaceService")

	if not CheckReached(pcall(MarketplaceService.GetProductInfo, MarketplaceService, Placeholder)) then
		error({Skipped = "calls aren't reaching Roblox, so it can't check what's blocked"})
	end

	const Unblocked = {}

	for _, Method in Methods do
		const ServiceName, MethodName = Method[1], Method[2]
		const Argument = if Method[3] == nil then Placeholder else Method[3]
		const Found, Service = pcall(game.GetService, game, ServiceName)

		if not Found then
			continue
		end

		const Reached = CheckReached(pcall(function()
			return Service[MethodName](Service, Argument)
		end)) or CheckReached(pcall(function()
			return (loadstring(`local Service, Argument = ... return Service:{MethodName}(Argument)`) :: Function)(Service, Argument)
		end))

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

			for _, Url in {
				"file:///C:/",
				"file:///C:/Windows/win.ini",
				"file:///C:/Windows/System32/drivers/etc/hosts",
			} do
				if Request then
					const Success, Response = pcall(Request, {
						Url = Url,
						Method = "GET",
					})

					assert(not Success or not Response or not Response.Success or Response.Body == "", "request can read files on your computer through file://")
				end

				for Name, Read in {
					["game:HttpGet"] = function()
						return game:HttpGet(Url)
					end,
					["game:HttpGetAsync"] = function()
						return game:HttpGetAsync(Url)
					end,
					["game:HttpPost"] = function()
						return game:HttpPost(Url, "")
					end,
				} do
					const ReadSuccess, ReadResult = pcall(Read)

					assert(not ReadSuccess or ReadResult == nil or ReadResult == "", `{Name} can read files on your computer through file://`)
				end
			end

			CheckMethodsBlocked({
				{"InsertService", "GetLocalFileContents", "rbxasset://fonts/families/SourceSansPro.json"},
			}, "read files on your computer")
		end,
	},

	["security: scripts can't write programs"] = {
		Test = function()
			const WriteFile = Formatters.CheckExist("writefile")
			const ListFiles = Formatters.CheckExist("listfiles")
			const IsFile = isfile or function() end
			const Written = {}

			const Extensions = {"exe", "bat", "cmd", "com", "scr", "ps1", "vbs", "lnk", "msi", "js", "jse", "vbe", "wsf", "hta", "dll", "jar", "reg", "cpl", "psm1"}
			const Names = {"debUNC.EXE", "debUNC.txt.exe", "debUNC.exe.", "debUNC.exe ", "debUNC.exe::$DATA", "debUNC.exe\0.txt"}
			const OwnNames = {"debunc.txt.exe", "debunc.renamed.exe", "debunc.moved.exe", "debunc.rename.txt", "debunc.move.txt"}
			const OutsideNames = {"../debUNC.exe", "../../debUNC.exe"}

			const function RemoveOwnFiles()
				local Success, Paths = pcall(ListFiles, "")

				if not Success then
					Success, Paths = pcall(ListFiles, ".")
				end

				for _, Path in if Success then Paths else {} do
					const Name = tostring(Path):lower():match("[^/\]*$")

					local IsOwn = table.find(Extensions, Name:match("^debunc%.(%w+)")) ~= nil

					for _, OwnName in OwnNames do
						IsOwn = IsOwn or Name:sub(1, #OwnName) == OwnName
					end

					if not IsOwn then
						continue
					end

					pcall(delfile, Path)

					if not table.find(Extensions, Name:match("%.(%w+)$")) or table.find(Written, tostring(Path)) then
						continue
					end

					table.insert(Written, tostring(Path))
				end

				for _, Name in OutsideNames do
					if select(2, pcall(IsFile, Name)) ~= true then
						continue
					end

					pcall(delfile, Name)

					if table.find(Written, Name) then
						continue
					end

					table.insert(Written, Name)
				end
			end

			AddCleanup(RemoveOwnFiles)

			for _, Extension in Extensions do
				table.insert(Names, `debUNC.{Extension}`)
			end

			for _, Name in OutsideNames do
				table.insert(Names, Name)
			end

			for _, Name in Names do
				pcall(WriteFile, Name, "debUNC")
				pcall(appendfile or WriteFile, Name, "debUNC")
			end

			for Name, Move in {
				renamefile = {"debUNC.rename.txt", "debUNC.renamed.exe"},
				movefile = {"debUNC.move.txt", "debUNC.moved.exe"},
			} do
				const MoveFile = getgenv()[Name]

				if not MoveFile then
					continue
				end

				pcall(WriteFile, Move[1], "debUNC")
				pcall(MoveFile, Move[1], Move[2])
			end

			RemoveOwnFiles()

			for _, Extension in Extensions do
				const Name = `debUNC.{Extension}`

				if table.find(Written, Name) or select(2, pcall(IsFile, Name)) ~= true then
					continue
				end

				table.insert(Written, Name)
				pcall(delfile, Name)
			end

			assert(#Written == 0, `scripts can write program files like {table.concat(Written, ", ")}, which could be run on your computer`)
		end,
	},

	["security: game scripts don't get executor powers"] = {
		Test = function()
			const SetThreadIdentity = Formatters.CheckExist("setthreadidentity")
			const GameLoadstring = Formatters.CheckExist("getrenv")().loadstring
			local Results

			task.spawn(function()
				SetThreadIdentity(2)

				if pcall(function()
					return game:GetService("CorePackages").Name
				end) then
					Results = {Lowered = false}
					return
				end

				const Leftover = {}

				for _, Service in {"VirtualInputManager", "VirtualUser"} do
					if game:FindService(Service) then
						table.insert(Leftover, Service)
					end
				end

				Results = {
					Lowered = true,
					Leftover = Leftover,
					Browser = pcall(function()
						game:GetService("BrowserService"):OpenBrowserWindow("")
					end),
					Locked = pcall(function()
						Instance.new("StringValue").RobloxLocked = true
					end),
					Loadstring = pcall(GameLoadstring, "return 1"),
				}
			end)

			WaitFor(function()
				return Results ~= nil
			end, 2)

			assert(Results, "a thread at identity 2 never finished")

			if not Results.Lowered then
				error({Skipped = "setthreadidentity didn't really lower the identity, so what game scripts can do couldn't be checked"})
			end

			assert(#Results.Leftover == 0, `{table.concat(Results.Leftover, " and ")} exists in the game, so game scripts can detect the executor through FindService`)

			const Leaks = {}

			if Results.Browser then
				table.insert(Leaks, "BrowserService:OpenBrowserWindow")
			end

			if Results.Locked then
				table.insert(Leaks, "setting RobloxLocked")
			end

			if Results.Loadstring then
				table.insert(Leaks, "loadstring")
			end

			assert(#Leaks == 0, `{table.concat(Leaks, ", ")} works at the game's own identity, which lets game scripts use executor powers`)
		end,
	},

	["security: files outside the workspace stay hidden"] = {
		Test = function()
			const FolderName = `debUNC{math.random(1, 1e6)}`
			const FilePath = `{FolderName}/debUNC.txt`

			AddCleanup(function()
				RemovePath("delfolder", FolderName)
			end)

			Formatters.CheckExist("makefolder")(FolderName)
			Formatters.CheckExist("writefile")(FilePath, "debUNC")

			const OutsideFiles = {"C:/Windows/win.ini", "../../../../../../Windows/win.ini", "/system/build.prop"}
			const OutsideFolders = {"C:/Windows", "C:/", "../../../../../../Windows", "/system"}

			const function IsFound(Success: boolean, Result: any): boolean
				if not Success or Result == nil or Result == false or Result == "" then
					return false
				end

				return typeof(Result) ~= "table" or next(Result) ~= nil
			end

			local Checked = 0

			for Name, Info in {
				isfolder = {
					Control = FolderName,
					Paths = OutsideFolders,
				},
				isfile = {
					Control = FilePath,
					Paths = OutsideFiles,
				},
				readfile = {
					Control = FilePath,
					Paths = OutsideFiles,
				},
				listfiles = {
					Control = FolderName,
					Paths = OutsideFolders,
				},
			} do
				const Check = getgenv()[Name]

				if not Check or not IsFound(pcall(Check, Info.Control)) then
					continue
				end

				Checked += 1

				for _, Path in Info.Paths do
					assert(not IsFound(pcall(Check, Path)), `{Name} can see '{Path}' outside of the workspace`)
				end
			end

			if Checked == 0 then
				error({Skipped = "none of the file functions could see a file inside of the workspace, so it can't check files outside of it"})
			end
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

			local Resolved = 0

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

				Resolved += 1

				const Reached, Balance = pcall(function()
					return Root:GetService("MarketplaceService"):GetRobuxBalance()
				end)

				if Reached and Balance ~= nil then
					table.insert(Bypasses, Name)
				end
			end

			if Resolved == 0 then
				error({Skipped = "none of the ways around the blocks gave back an instance to check"})
			end

			assert(#Bypasses == 0, `{table.concat(Bypasses, ", ")} reached a method that's blocked everywhere else`)
		end,
	},
}

for Name, Info in Tests do
	if not Name:find("^raknet%.") or not Info.Test then
		continue
	end

	const Test = Info.Test

	Info.Test = function()
		const Success, ErrorMessage = pcall(Test)

		if Success then
			return
		end

		if typeof(ErrorMessage) == "string" and ErrorMessage:lower():find("not enabled") then
			error({Skipped = "raknet isn't enabled in the executor's settings"})
		end

		error(ErrorMessage, 0)
	end
end

for Name, Info in SecurityTests do
	Info.Security = true
	Tests[Name] = Info
end

const NoTests: {[string | number]: any} = {
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

	rconsolesettitle = {
		Test = function()
			CheckConsole()
			rconsolesettitle("debUNC")
		end,
		RunLast = true,
	},

	rconsoleclear = {
		Test = function()
			CheckConsole()
			rconsoleclear()
		end,
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

		end,
		RunLast = true,
	},

	messagebox = {
		Test = function()
			const MessageBox = messagebox
			const BoxStartTime = os.clock()

			local Frames = 0

			const Connection = game:GetService("RunService").Heartbeat:Connect(function()
				Frames += 1
			end)

			task.spawn(pcall, MessageBox, "debUNC test, you can close this", "debUNC", 0)
			task.wait(1)
			Connection:Disconnect()

			const Elapsed = os.clock() - BoxStartTime

			MessageBoxTime = math.max(Elapsed - 1, 0)

			assert(Elapsed < 2 and Frames > 10, `Roblox froze while the message box was open, only {Frames} frames ran in {math.floor(Elapsed * 10) / 10} seconds`)
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

local ExecutorName, ExecutorVersion = (identifyexecutor or function()
	return "Unknown Executor", "0.0.0"
end)()

ExecutorName = ExecutorName or "Unknown Executor"
ExecutorVersion = ExecutorVersion or "0.0.0"

local WriteLog = function(_Message: string) end

const function DisplayMessage(Message: string)
	WriteLog(Message)

	if ExecutorName == "AWP" then
		print(Message)
		return
	end

	if not pcall(LogService.Info, LogService, Message) then
		print(Message)
	end
end

const Settings: {[string]: any} = {
	DebugMode = false,
	CrashTests = false,
	LogResults = false,
	TeleportTests = false,
}

for Name in Settings do
	const Saved = shared[Name]

	if Saved == nil then
		continue
	end

	Settings[Name] = Saved
end

const TeleportFile = "debUNC teleport.txt"
const QueuedFile = "debUNC queued.txt"
const ClearedFile = "debUNC cleared.txt"

const function IsFile(Path: string): boolean
	return isfile ~= nil and select(2, pcall(isfile, Path)) == true
end

if IsFile(TeleportFile) then
	const Token = readfile(TeleportFile)

	TeleportResults.Queued = IsFile(QueuedFile) and readfile(QueuedFile) == Token

	if TeleportResults.Queued then
		TeleportResults.Cleared = IsFile(ClearedFile)
	end

	for _, Path in {TeleportFile, QueuedFile, ClearedFile} do
		pcall(delfile, Path)
	end
elseif Settings.TeleportTests and writefile and readfile then
	const QueueOnTeleport = FindFirstFunction("queueonteleport") or FindFirstFunction("queue_on_teleport") or FindFirstFunction("queue_teleport") or FindFirstFunction("queueteleport")
	const ClearQueueOnTeleport = FindFirstFunction("clearqueueonteleport") or FindFirstFunction("clear_teleport_queue") or FindFirstFunction("clearteleportqueue")

	if QueueOnTeleport then
		const Token = tostring(math.random(1, 1e9))
		const SettingLines = {}

		for Name, Value in Settings do
			table.insert(SettingLines, `shared.{Name} = {Value}`)
		end

		writefile(TeleportFile, Token)

		if ClearQueueOnTeleport then
			pcall(QueueOnTeleport, `writefile("{ClearedFile}", "")`)
			pcall(ClearQueueOnTeleport)
		end

		pcall(QueueOnTeleport, `{table.concat(SettingLines, " ")} writefile("{QueuedFile}", "{Token}") loadstring(game:HttpGet("https://github.com/alyssagithub/debUNC/raw/main/debUNC.luau"))()`)
		DisplayMessage("Rejoining to test queueonteleport, debUNC will run again after the teleport.")
		game:GetService("TeleportService"):Teleport(game.PlaceId, Player)

		do
			return
		end
	end
end

local LogPath: string?

if Settings.LogResults and writefile and appendfile then
	const Path = `debUNC logs/debUNC {(ExecutorName:gsub("[^%w%s%.%-_]", ""))} {os.date("%Y-%m-%d %H-%M-%S")}.txt`

	pcall(makefolder, "debUNC logs")

	if pcall(writefile, Path, "") then
		LogPath = Path
	end
end

WriteLog = function(Message: string)
	if not LogPath then
		return
	end

	pcall(appendfile, LogPath, `[{os.date("%H:%M:%S")}] {Message}\n`)
end

const RobloxPrint, RobloxWarn = print, warn

const function JoinMessage(...): string
	const Parts = table.pack(...)

	for Index = 1, Parts.n do
		Parts[Index] = tostring(Parts[Index])
	end

	return table.concat(Parts, " ", 1, Parts.n)
end

local function print(...)
	const Message = JoinMessage(...)

	if not pcall(LogService.Output, LogService, Message) then
		RobloxPrint(...)
	end

	WriteLog(Message)
end

local function warn(...)
	const Message = JoinMessage(...)

	if not pcall(LogService.Warn, LogService, Message) then
		RobloxWarn(...)
	end

	WriteLog(Message)
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
const ChunkName = tostring(select(2, pcall(function()
	error("debUNC")
end))):match("^(.*):%d+: debUNC$")

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

		local LastError

		for Attempt = 1, 3 do
			const AttemptSuccess, AttemptError = pcall(Info.Test)

			if AttemptSuccess then
				return
			end

			if typeof(AttemptError) == "table" and AttemptError.Skipped then
				error(AttemptError, 0)
			end

			LastError = AttemptError

			const Interfered = InputInterference[Name] == true

			if not (Info.Retry or InputTests[Name]) or (Attempt == 2 and not Interfered) then
				break
			end

			if Attempt == 3 and Interfered then
				error({Skipped = "the mouse or keyboard was being used during the test", Environment = true})
			end

			RunCleanups(coroutine.running())
		end

		error(LastError, 0)
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

	if not Settings.DebugMode and ChunkName and tostring(ErrorMessage):sub(1, #ChunkName + 1) == `{ChunkName}:` then
		ErrorMessage = tostring(ErrorMessage):sub(#ChunkName + 2):gsub("^%d+: ", "")
	end

	const Message = tostring(ErrorMessage)

	if not Missing and InputTests[Name] and not IsRobloxFocused() and (Message:find("wasn't detected") or Message:find("never held") or Message:find("^the mouse ")) then
		ErrorMessage = `{ErrorMessage} while Roblox wasn't focused, input should still reach Roblox`
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
const StartTime = os.clock()

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

for _, Name in {"rconsolecreate", "rconsoleprint", "rconsoleinfo", "rconsolewarn", "rconsoleerr", "rconsolesettitle", "rconsoleclear", "rconsoledestroy", "isrbxactive", "messagebox"} do
	table.insert(LastTests, table.remove(LastTests, table.find(LastTests, Name)))
end

MoveFocusToConsole()

for _, Name in LastTests do
	if Name == "rconsolecreate" then
		pcall(rconsoledestroy or function() end)
	end

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

const FailedNames = {}

for Name in FailureMessages do
	table.insert(FailedNames, Name)
end

table.sort(FailedNames)

for _, Name in FailedNames do
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

	const FailureLine = `🔴 {Name}: {FailureMessages[Name]}`
	const Logged, LogError = pcall(LogService.Error, LogService, FailureLine)

	if Logged or tostring(LogError):find(FailureLine, 1, true) then
		WriteLog(FailureLine)
	else
		warn(FailureLine)
	end
	FailedTests += 1
end

const ElapsedTime = os.clock() - StartTime - MessageBoxTime
const PercentageComplete = math.floor(CompletedTests / math.max(TotalTests - EnvironmentSkips, 1) * 100)
const MinimumSeconds = 0.1

task.wait(0.5)

if ElapsedTime < MinimumSeconds and PercentageComplete > 80 then
	DisplayMessage(`This test is most likely faked as it took less than {MinimumSeconds} seconds.`)
end

DisplayMessage("❓ The score below is only for how many custom functions are supported and secure.")
DisplayMessage(`🔵 debUNC v2.14.0 Score for {ExecutorName} {ExecutorVersion}: {PercentageComplete}%`)
DisplayMessage(`🟣 Total tests: {TotalTests} (Took {math.floor(ElapsedTime * 100) / 100} seconds)`)
DisplayMessage(`🟢 Successful tests: {CompletedTests}`)
DisplayMessage(`🔴 Failed tests: {FailedTests}`)
DisplayMessage(`🟠 Skipped tests: {UntestableTests}`)
DisplayMessage(`🟡 Missing functions: {MissingFunctions}`)
DisplayMessage("Join our NEW discord server @ discord.gg/rEVTBKFDSP")

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

if LogPath then
	DisplayMessage(`Logged results are available at {LogPath}`)
end