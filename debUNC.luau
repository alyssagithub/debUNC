--!strict
type Function = (...any?) -> ...any?

-- didn't return a {Type}
local function CheckReturnType(Result: any, Type: string)
	assert(typeof(Result) == Type, `didn't return a {Type}`)
end

local function FindFirstFunction(Name: string, Environment: {[string]: any}?): any
	local Value = Environment or getfenv()

	while Value ~= nil and Name ~= "" do
		local Library, NewName = string.match(Name, "^([^.]+)%.?(.*)$")

		Value = Value[Library or ""]
		Name = NewName or ""
	end

	return Value
end

-- '{FunctionName}' does not exist, and is required for this test
local function CheckExist(FunctionName: string): any
	local Function = FindFirstFunction(FunctionName)

	assert(Function, `'{FunctionName}' does not exist, and is required for this test`)
	return Function
end

-- failed to find {Name}, retry this test
local function FailedFind(Name: string)
	return `failed to find {Name}, retry this test`
end

local Tests: any = {
	getrenv = {
		Test = function()
			local getrenv: () -> {[string]: any} = getfenv().getrenv

			local ExpectedGlobals = {
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
			}

			local Environment = getrenv()

			for _, Global: string in ExpectedGlobals do
				assert(Environment[Global] ~= nil, `missing '{Global}'`)
			end
		end,
		ReturnType = "table"
	},

	getgenv = {
		Test = function()
			local getgenv: () -> {[string]: any} = getfenv().getgenv

			local Environment = getgenv()

			for FunctionName in getfenv() do
				assert(Environment[FunctionName], `missing '{FunctionName}'`)
			end
		end,
		ReturnType = "table",
	},

	gettenv = {
		Test = function()
			local gettenv: (thread | () -> ()) -> {[string]: any} = getfenv().gettenv

			local Success = pcall(gettenv, function() end)

			assert(not Success, "expected error when providing a non-thread value")

			local ThreadEnvironment = gettenv(task.spawn(function() end))

			CheckReturnType(ThreadEnvironment, "table")

			for FunctionName in ThreadEnvironment do
				assert(getfenv()[FunctionName], `Function does not contain all values in getfenv(). Missing value: {FunctionName}`)
			end
		end,
	},

	readfile = {
		Test = function()
			local readfile: (Path: string) -> string = getfenv().readfile

			local Success, Result = pcall(readfile, "doesntexist.txt")

			assert(not Success, "expected an error when reading a file that doesn't exist")

			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")

			local GeneratedResult = tostring(math.random())
			local FileName = `File_{math.random()}.txt`

			writefile(FileName, GeneratedResult)

			local Result = readfile(FileName)

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end

			assert(Result == GeneratedResult, "Test file did not return what was written into it.")
		end
	},

	writefile = {
		Test = function()
			local writefile: (Path: string, Data: string) -> () = getfenv().writefile

			local readfile: (Path: string) -> string = CheckExist("readfile")

			local GeneratedResult = tostring(math.random())
			local FileName = `File_{math.random()}.txt`

			writefile(FileName, GeneratedResult)

			local Result = readfile(FileName)

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end

			assert(typeof(Result) == "string", "'readfile' failed to read the file, cannot continue test.")

			assert(Result == GeneratedResult, "'writefile' did not write to the file.")
		end
	},

	isfile = {
		Test = function()
			local isfile: (Path: string) -> boolean = getfenv().isfile

			local FileName = `File_{math.random()}.txt`

			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")

			writefile(FileName, "Test")

			local Exists = isfile(FileName)

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end

			assert(Exists, "failed to find the file")
		end
	},

	appendfile = {
		Test = function()
			local appendfile: (Path: string, Data: string) -> () = getfenv().appendfile

			local readfile: (Path: string) -> string = CheckExist("readfile")

			local GeneratedResult = tostring(math.random())
			local FileName = `File_{math.random()}.txt`

			local Success = pcall(appendfile, FileName, GeneratedResult)

			if not Success then
				CheckExist("writefile")(FileName, GeneratedResult)
			end

			assert(readfile(FileName) == GeneratedResult, "failed to create the file")

			appendfile(FileName, "Append")

			local HasAppend = readfile(FileName):find("Append")

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end

			assert(HasAppend, "failed to add to the existing file")
		end
	},

	listfiles = {
		Test = function()
			local listfiles: (Path: string) -> {string} = getfenv().listfiles
			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")
			local makefolder: (Path: string) -> () = CheckExist("makefolder")

			local FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			assert(typeof(listfiles(FolderName)) == "table", "Function did not return a table.")

			local GeneratedResult = tostring(math.random())
			local FileName = `{FolderName}\\{`File_{math.random()}.txt`}`

			writefile(FileName, GeneratedResult)

			local Result = listfiles(FolderName)

			local delfolder: (Path: string) -> () = getfenv().delfolder

			if delfolder then
				delfolder(FolderName)
			end

			assert(Result[1] == FileName, "Function did not find the written file.")
		end
	},

	delfile = {
		Test = function()
			local delfile: (Path: string) -> any? = getfenv().delfile
			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")
			local isfile: (Path: string) -> boolean = CheckExist("isfile")

			local FileName = `File_{math.random()}.txt`

			writefile(FileName, "Test")

			assert(isfile(FileName), "Failed to write to the file, cannot continue test.")

			delfile(FileName)

			assert(not isfile(FileName), "'isfile' returned true after file was meant to be deleted.")
		end
	},

	loadfile = {
		Test = function()
			local loadfile: (Path: string, ChunkName: string?) -> ((any?) -> (any?)?, string?) = getfenv().loadfile

			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")

			local FileName = `File_{math.random()}.txt`
			local GeneratedNumber = math.random()

			writefile(FileName, "local number = ...; return number + 1")

			local LoadedFunction, Error = loadfile(FileName)

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end

			local Result = assert(LoadedFunction, Error)(GeneratedNumber)

			assert(Result == GeneratedNumber + 1, "Function did not return the correct number.")
		end
	},

	makefolder = {
		Test = function()
			local makefolder: (Path: string) -> () = getfenv().makefolder
			local isfolder: (Path: string) -> boolean = CheckExist("isfolder")

			local FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			assert(isfolder(FolderName) == true, "failed to find folder after it was made")

			local delfolder: (Path: string) -> () = getfenv().delfolder

			if delfolder then
				delfolder(FolderName)
			end
		end
	},

	isfolder = {
		Test = function()
			local isfolder: (Path: string) -> boolean = getfenv().isfolder

			local makefolder: (Path: string) -> () = CheckExist("makefolder")

			assert(isfolder("???") == false, "didn't return false for non-existent folder")

			local FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			assert(isfolder(FolderName), "Folder was not found after it was made.")

			local delfolder: (Path: string) -> () = getfenv().delfolder

			if delfolder then
				delfolder(FolderName)
			end
		end
	},

	delfolder = {
		Test = function()
			local delfolder: (Path: string) -> () = getfenv().delfolder

			local makefolder: (Path: string) -> () = CheckExist("makefolder")

			local isfolder: (Path: string) -> boolean = CheckExist("isfolder")

			local FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			assert(isfolder(FolderName), "failed to find folder after it was made")

			delfolder(FolderName)

			assert(not isfolder(FolderName), "'isfolder' found the folder after it should've been deleted.")
		end
	},

	hookfunction = {
		Test = function()
			local hookfunction: (FunctionToHook: (...any) -> (...any), Hook: () -> ()) -> () -> () = getfenv().hookfunction
			local newcclosure: (((...any) -> ...any) -> (...any) -> ...any)? = getfenv().newcclosure

			local function HookTest(FunctionToHook, Hook: (...any) -> ...any, ...)
				local Original = hookfunction(FunctionToHook, Hook)

				local Test = Hook(...)

				local Success, Result = pcall(FunctionToHook, ...)

				assert(Success, `errored with '{Result}' while running test {Test}`)

				assert(Result == Test, `{Test} didn't return the expected value`)

				hookfunction(FunctionToHook, Original) -- restorefunction
			end

			--lclosures

			HookTest(function()end, function()
				return "lclosure -> lclosure"
			end)

			HookTest(function()end, string.upper, "lclosure -> cclosure")

			if newcclosure then
				HookTest(function()end, newcclosure(function()
					return "lclosure -> newcclosure"
				end))
			end

			--cclosures

			HookTest(string.upper, function()
				return "cclosure -> lclosure"
			end)

			HookTest(string.lower, string.upper, "cclosure -> cclosure")

			if newcclosure then
				HookTest(string.lower, newcclosure(function()
					return "cclosure -> newcclosure"
				end))
			end

			--newcclosures

			if not newcclosure then
				return
			end

			HookTest(newcclosure(function()end), function()
				return "newcclosure -> lclosure"
			end)

			HookTest(newcclosure(function()end), string.upper, "newcclosure -> cclosure")

			HookTest(newcclosure(function()end), newcclosure(function()
				return "newcclosure -> newcclosure"
			end))
		end
	},

	iscclosure = {
		Test = function()
			local iscclosure: (Function: (any?) -> ()) -> (boolean) = getfenv().iscclosure

			assert(iscclosure(assert) == true, "function 'assert' is a c closure")

			assert(not iscclosure(function() end), "A function created in the executor is not written in C.")
		end,
	},

	clonefunction = {
		Test = function()
			local clonefunction: ((any?) -> any?) -> ((any?) -> any?) = getfenv().clonefunction

			local GeneratedNumber = math.random()

			local function Original()
				return GeneratedNumber
			end

			local Clone = clonefunction(Original)

			assert(Clone ~= Original, "Cloned and original function should not have the same reference.")

			assert(Clone() == Original(), "Cloned and original function should return the same value.")
		end
	},

	request = {
		Test = function()
			type Request = {
				StatusCode: number,
				StatusMessage: string,
				Headers: {
					Connection: string,
					["Content-Length"]: number,
					["Access-Control-Allow-Credentials"]: boolean,
					["Access-Control-Allow-Origin"]: string,
					Date: string,
					["Content-Type"]: string,
					Server: string
				},
				Body: string
			}

			type Parameters = {
				Url: string,
				Body: string?,
				Method: string,
				Headers: {
					["Content-Type"]: "application/json"
				}?
			}

			local request: (Parameters) -> Request = getfenv().request

			local Result = request({
				Url = "https://httpbin.org/get",
				Method = "GET"
			})

			CheckReturnType(Result, "table")

			assert(Result.StatusCode == 200, `failed to request, StatusMessage: {Result.StatusMessage}, StatusCode: {Result.StatusCode}`)

			assert(Result.StatusMessage == "OK", `StatusMessage should be 'OK' when the StatusCode is 200`)

			local Body = Result.Body

			assert(typeof(Body) == "string", "expected a string from the Body")

			local Decoded = game:GetService("HttpService"):JSONDecode(Body)

			CheckReturnType(Decoded, "table")

			local DecodedHeaders = Decoded.headers

			assert(DecodedHeaders, "Decoded body does not contain the headers.")

			local Fingerprint

			for i,v in DecodedHeaders do
				if i:lower():find("fingerprint") then
					Fingerprint = v
					break
				end
			end

			assert(Fingerprint, "Decoded headers does not contain an executor fingerprint.")
		end
	},

	require = {
		Test = function()
			local Module = game:FindFirstChildWhichIsA("ModuleScript", true)

			assert(Module, FailedFind("module"))

			local Success, Result = pcall(require, Module)

			assert(Success, `expected success when requiring '{Module.Name}', got error: {Result}`)

			assert(Result ~= nil, "expected a value to be returned, got nil")
		end
	},

	fireclickdetector = {
		Test = function()
			local fireclickdetector: (ClickDetector) -> () = getfenv().fireclickdetector

			local ClickDetector = Instance.new("ClickDetector")

			local WasClicked = false

			ClickDetector.MouseClick:Once(function(Player)
				if Player == game:GetService("Players").LocalPlayer then
					WasClicked = true
				end
			end)

			fireclickdetector(ClickDetector)

			local Start = tick()

			repeat
				task.wait()
			until WasClicked or tick() - Start >= 1

			assert(WasClicked, "connection was not fired")
		end
	},

	fireproximityprompt = {
		Test = function()
			local fireproximityprompt: (ProximityPrompt: ProximityPrompt) -> () = getfenv().fireproximityprompt

			local Part = Instance.new("Part")
			Part.Parent = workspace

			local ProximityPrompt = Instance.new("ProximityPrompt")
			ProximityPrompt.Parent = Part

			local WasTriggered = false

			ProximityPrompt.Triggered:Once(function(Player)
				if Player == game:GetService("Players").LocalPlayer then
					WasTriggered = true
				end
			end)

			fireproximityprompt(ProximityPrompt)

			local Start = tick()

			repeat
				task.wait()
			until WasTriggered or tick() - Start >= 1

			Part:Destroy()

			assert(WasTriggered, "connection was not fired")
		end
	},

	firesignal = {
		Test = function()
			local firesignal: (RBXScriptSignal, any?) -> () = getfenv().firesignal

			local NumberValue = Instance.new("NumberValue")

			local GeneratedValue = math.random()

			local DidChange = false

			NumberValue.Changed:Once(function(Value)
				if Value == GeneratedValue then
					DidChange = true
				end
			end)

			firesignal(NumberValue.Changed, GeneratedValue)

			local Start = tick()

			repeat
				task.wait()
			until DidChange or tick() - Start >= 1

			assert(DidChange, "connection was not fired")
		end
	},

	getloadedmodules = {
		Test = function()
			local getloadedmodules: () -> {ModuleScript} = getfenv().getloadedmodules

			local Module = game:FindFirstChildWhichIsA("ModuleScript", true)

			assert(Module, FailedFind(`ModuleScript '{Module}'`))

			local LoadedModules = getloadedmodules()

			local require: any = require

			if not table.find(LoadedModules, Module) then
				require(Module)

				LoadedModules = getloadedmodules()
			end

			assert(table.find(LoadedModules, Module), `failed to find ModuleScript '{Module}' in table`)
		end,
		ReturnType = "table"
	},

	getconnections = {
		Test = function()
			type Connections = {
				RBXScriptConnection & {
					Fire: (self: RBXScriptConnection, any?) -> ()
				}
			}

			local getconnections: (RBXScriptSignal) -> Connections = getfenv().getconnections

			local NumberValue = Instance.new("NumberValue")

			local DidChange = false

			local GeneratedValue = math.random()

			NumberValue.Changed:Once(function(Value)
				assert(
					GeneratedValue == Value, 
					`connection was fired but improper parameter given, expected number '{GeneratedValue}', got {typeof(Value)} '{Value}'`
				)

				if GeneratedValue == Value then
					DidChange = true
				end
			end)

			local Connections = getconnections(NumberValue.Changed)

			assert(typeof(Connections) == "table", `expected a table, got {typeof(Connections)}`)

			assert(#Connections == 1, `expected 1 connection in the table, got {#Connections}`)

			local ChangedConnection = Connections[1]

			assert(ChangedConnection.Fire, "expected method 'Fire' in the table")

			ChangedConnection:Fire(GeneratedValue)

			local Start = tick()

			repeat
				task.wait()
			until DidChange or tick() - Start >= 1

			assert(DidChange, "connection was not fired")
		end
	},

	getscripts = {
		Test = function()
			local getscripts: () -> {BaseScript} = getfenv().getscripts

			for _, CurrentScript: BaseScript | ModuleScript in getscripts() do
				assert(typeof(CurrentScript) == "Instance", `expected instance, got {typeof(CurrentScript)} '{CurrentScript}'`)

				local ClassCheck = CurrentScript:IsA("BaseScript") or CurrentScript:IsA("ModuleScript")

				assert(ClassCheck, `instance '{CurrentScript}' is not a script, ClassName: {CurrentScript.ClassName}`)
			end
		end,
		ReturnType = "table"
	},

	setfpscap = {
		Test = function()
			local setfpscap: (FPSCap: number) -> () = getfenv().setfpscap

			local function GetCurrentFPS(): number
				return math.floor(1 / game:GetService("Stats").FrameTime)
			end

			local HighestFPS = 0
			local LastPeak = tick()

			while tick() - LastPeak <= 0.25 and task.wait() do
				local FPS = GetCurrentFPS()

				if FPS == math.huge then
					continue
				end

				if FPS > HighestFPS then
					HighestFPS = FPS
					LastPeak = tick()
				end
			end

			local FPSCap = math.floor(HighestFPS / 6)

			setfpscap(FPSCap)

			local StartLoop = tick()

			local FPS

			local Timeout = 5

			repeat
				FPS = GetCurrentFPS()
				task.wait()
			until FPS <= FPSCap or tick() - StartLoop >= Timeout

			setfpscap(0)

			assert(FPS <= FPSCap, `fps ({FPS}) did not go below {FPSCap} within {Timeout} seconds`)
		end
	},

	base64encode = {
		Test = function()
			local base64encode: (string) -> string = getfenv().base64encode

			local base64decode: (string) -> string = CheckExist("base64decode")

			local GeneratedString = tostring(math.random())

			local Encoded = base64encode(GeneratedString)

			assert(Encoded ~= GeneratedString, "encoded result did not change from the original string")

			local Decoded = base64decode(Encoded)

			assert(Decoded == GeneratedString, "decoded result did not provide the original string")
		end
	},

	getfpscap = {
		Test = function()
			local getfpscap: () -> number = getfenv().getfpscap

			local setfpscap: (FPSCap: number) -> () = CheckExist("setfpscap")

			setfpscap(10)

			local Result = getfpscap()

			assert(Result == 10, `expected value '10', got '{Result}'`)

			setfpscap(0)

			local NewResult = getfpscap()

			assert(NewResult ~= Result, "set fps cap to 0, result stayed at 10")
		end,
	},

	newcclosure = {
		Test = function()
			local newcclosure: ((...any) -> ...any) -> (...any) -> ...any = getfenv().newcclosure

			local function TestFunction()
				return "debunc"
			end

			local NewClosure = newcclosure(TestFunction)

			assert(debug.info(NewClosure, "s") == "[C]", `expected the returned closure to be in [C], got '{debug.info(NewClosure, "s")}'`)

			assert(NewClosure ~= TestFunction, "function returned is the same as the function given")

			assert(NewClosure() == "debunc", "failed to return the expected value")
		end,
	},

	isscriptable = {
		Test = function()
			local isscriptable: (Object: Object, Property: string) -> boolean = getfenv().isscriptable

			assert(isscriptable(game, "Parent") == true, "game.Parent is scriptable")

			local Success, Result = pcall(isscriptable, game, "SimulationRadius")

			assert(not Success or Result == false, "game.SimulationRadius is a hidden property, and isn't scriptable")

			local Success, Result = pcall(isscriptable, game, "a")

			assert(not Success or not Result, "game.a is not a valid property")
		end,
	},

	firetouchinterest = {
		Test = function()
			local firetouchinterest: (FireTouch: BasePart, WithPart: BasePart, Ended: number) -> () = getfenv().firetouchinterest

			local FireTouch = Instance.new("Part")
			local WithPart = Instance.new("Part")

			FireTouch.Parent = workspace
			WithPart.Parent = workspace

			local Complete = false

			FireTouch.Touched:Connect(function(Part)
				if WithPart == Part then
					Complete = true
				end
			end)

			firetouchinterest(FireTouch, WithPart, 0)
			firetouchinterest(FireTouch, WithPart, 1)

			local Start = tick()

			repeat
				task.wait()
			until Complete or tick() - Start >= 5

			FireTouch:Destroy()
			WithPart:Destroy()

			assert(Complete, "failed to fire the touched event within 5 seconds")
		end,
	},

	hookmetamethod = {
		Test = function() -- credit to dante for contributing to this
			local hookmetamethod: (Metatable: any, Metamethod: string, Hook: Function) -> Function = getfenv().hookmetamethod

			local OriginalIndx = function() end
			local Metatable = setmetatable({}, {__index = OriginalIndx})

			local Original = hookmetamethod(Metatable, "__index", function()
				return "debUNC"
			end)

			CheckReturnType(Original, "function")

			assert(Metatable.yay == "debUNC", "indexing the metatable failed to return the hooked value")
			assert(getmetatable(Metatable).__index == OriginalIndx, "function replaced the metamethod's function instead of it's proto")
		end,
	},

	["WebSocket.connect"] = {
		Test = function()
			local connect: (WebSocket: string) -> {[any]: any} = getfenv().WebSocket.connect

			local WebSocket = connect("ws://echo.websocket.events")

			--CheckReturnType(WebSocket, "userdata")

			assert(typeof(WebSocket.Send) == "function", "missing 'Send' function")

			assert(typeof(WebSocket.Close) == "function", "missing 'Close' function")

			assert(typeof(WebSocket.OnMessage) == "RBXScriptSignal", "missing 'OnMessage' RBXScriptSignal")

			assert(typeof(WebSocket.OnClose) == "RBXScriptSignal", "missing 'OnClose' RBXScriptSignal")

			local Messaged = false

			WebSocket.OnMessage:Once(function()
				Messaged = true
			end)

			WebSocket:Send("debUNC")

			local Start = tick()

			repeat
				task.wait()
			until Messaged or tick() - Start >= 5

			WebSocket:Close()

			assert(Messaged, "failed to receive message within 5 seconds")
		end,
	},

	["cache.invalidate"] = {
		Test = function() -- skidded from unc
			local invalidate = getfenv().cache.invalidate

			local container = Instance.new("Folder")
			local part = Instance.new("Part", container)
			invalidate(container:FindFirstChild("Part"))
			assert(part ~= container:FindFirstChild("Part"), "Reference `part` could not be invalidated")
		end,
	},

	["cache.iscached"] = {
		Test = function() -- skidded from unc
			local iscached = getfenv().cache.iscached
			local invalidate = CheckExist("cache.invalidate")

			local part = Instance.new("Part")
			assert(iscached(part), "Part should be cached")
			invalidate(part)
			assert(not iscached(part), "Part should not be cached")
		end,
	},

	["cache.replace"] = {
		Test = function() -- skidded from unc
			local replace = getfenv().cache.replace

			local part = Instance.new("Part") :: Instance
			local fire = Instance.new("Fire") :: Instance
			replace(part, fire)
			assert(part ~= fire, "Part was not replaced with Fire")
		end,
	},

	cloneref = {
		Test = function() -- skidded from unc
			local cloneref = getfenv().cloneref

			local part = Instance.new("Part")
			local clone = cloneref(part)
			assert(part ~= clone, "Clone should not be equal to original")
			clone.Name = "Test"
			assert(part.Name == "Test", "Clone should have updated the original")
		end,
	},

	compareinstances = {
		Test = function() -- skidded from unc
			local compareinstances = getfenv().compareinstances
			local cloneref = CheckExist("cloneref")

			local part = Instance.new("Part")
			local clone = cloneref(part)
			assert(part ~= clone, "Clone should not be equal to original")
			assert(compareinstances(part, clone), "Clone should be equal to original when using compareinstances()")
		end,
	},

	checkcaller = {
		Test = function()
			-- TODO: make this test check situations where it'd return false
			assert(getfenv().checkcaller() == true, "should return true when called by the executor")
		end,
	},

	isfunctionhooked = {
		Test = function()
			local isfunctionhooked: ((...any?) -> ...any?) -> boolean = getfenv().isfunctionhooked
			local hookfunction = CheckExist("hookfunction")

			local function Test()
				return "debUNC Original"
			end

			assert(isfunctionhooked(Test) == false, "an unhooked function should return false")

			hookfunction(Test, function()
				return "debUNC Hooked"
			end)

			assert(isfunctionhooked(Test) == true, "a hooked function should return true")

			local restorefunction = getfenv().restorefunction

			if not restorefunction then
				return
			end

			restorefunction(Test)

			assert(isfunctionhooked(Test) == false, "a restored hooked function should return false")
		end,
	},

	base64decode = {
		Test = function()
			local base64decode: (Encoded: string) -> string = getfenv().base64decode

			assert(base64decode("ZGVidW5j") == "debunc", "failed to decode a string encoded in base64")
		end,
	},

	setrawmetatable = {
		Test = function() -- credit to dante for making this
			local setrawmetatable: (Table: {[any]: any}, Metatable: {[any]: any}) -> () = getfenv().setrawmetatable

			local LockedProxy = newproxy()

			assert(getmetatable(LockedProxy) == nil, "a new proxy shouldn't have a metatable")

			local MainMeta = {
				__call = function()
					return "debUNC"
				end
			}

			setrawmetatable(LockedProxy, MainMeta)

			assert(getmetatable(LockedProxy) == MainMeta, "the new proxy's metatable was not set to the expected one")

			local Success, Result = pcall(LockedProxy)

			assert(Success, `errored while attempting to call the new proxy, error: {Result}`)
			assert(Result == "debUNC", "calling the new proxy failed to return the expected value")
		end,
	},

	lz4compress = {
		Test = function()
			local lz4compress: (String: string) -> string = getfenv().lz4compress

			assert(lz4compress("debUNC") == "`debUNC", "failed to compress the string with lz4")
		end,
	},

	lz4decompress = {
		Test = function()
			local lz4decompress: (Compressed: string, Allocation: number) -> string = getfenv().lz4decompress

			local String = "`debUNC"

			assert(lz4decompress(String, #String):find("debUNC"), "failed to decompress the string with lz4")
		end,
	},

	["debug.getproto"] = {
		Test = function()
			local getproto: (Function: (...any?) -> ...any?, Index: number) -> ((...any?) -> ...any?)? = CheckExist("debug.getproto")

			local Proto = getproto(function()
				local function b()
					return "debUNC"
				end	
			end, 1)

			assert(typeof(Proto) == "function", "didn't return a function")

			assert(Proto() == "debUNC", "calling the proto failed to return the expected value")
		end,
	},

	["debug.getprotos"] = {
		Test = function()
			local getprotos: (Function: (...any?) -> ...any?) -> {(...any?) -> ...any?} = CheckExist("debug.getprotos")

			local Protos = getprotos(function()
				local function b()
					return "debUNC"
				end	
			end)

			assert(typeof(Protos) == "table", "didn't return a table")

			assert(#Protos == 1, "expected table to be an array with only 1 index")

			assert(Protos[1]() == "debUNC", "calling the proto within the table failed to return the expected value")
		end,
	},

	getnamecallmethod = {
		Test = function() -- credit to dante for making this test
			local getnamecallmethod: () -> string = getfenv().getnamecallmethod

			local ProxyTest = newproxy(true)
			local Detected

			getmetatable(ProxyTest).__namecall = function()
				Detected = getnamecallmethod()
			end

			local Success, Result = pcall(function()
				ProxyTest:debUNC()
			end)

			local OutsideMethod = getnamecallmethod()

			assert(Success, `errored while attempting to call the new proxy with namecall, error: {Result}`)
			assert(Detected == "debUNC", `getnamecallmethod gave '{Detected}' instead of 'debUNC' inside __namecall`)
			assert(OutsideMethod == "debUNC", `getnamecallmethod gave '{OutsideMethod}' instead of 'debUNC' outside __namecall`)
		end,
	},

	getcallingscript = {
		Test = function() -- credit to dante
			local getcallingscript = getfenv().getcallingscript

			local Success, CameraModule = pcall(function()
				return game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule.CameraModule
			end)

			assert(Success, "BaseCamera does not exist, go to a normal game.")

			local Success, Camera = pcall(require, CameraModule.BaseCamera)
			
			assert(Success, `failed to require BaseCamera with error: {Camera}`)

			local LastError, SecureGET = nil, true

			local CallingCheck = setmetatable({}, {
				__newindex = function()
					local CallScript = getcallingscript() 
					if typeof(CallScript) ~= "Instance" then
						LastError = "do not save scripts, possibly use getfenv"
					elseif CallScript == CameraModule.BaseCamera then
						LastError = "returned from where it is a function, not from where it is executed."
					elseif CallScript == CameraModule then
						LastError = "added an extra stack level, gave caller's caller."
					elseif CallScript ~= CameraModule.ClassicCamera then
						LastError = `returned "{CallScript:GetFullName()}" instead of “ClassicCamera”.`
					end
				end
			})

			local Old, Called = Camera.GetSubjectPosition, false
			Camera.GetSubjectPosition = function(...)
				local getfenv, setfenv, pcall = getfenv, setfenv, pcall

				Camera.GetSubjectPosition = Old

				local Succes, OriginalENV = pcall(getfenv, 3)
				pcall(setfenv, 3, setmetatable({}, {
					__index = function()
						SecureGET = false
					end,
				}) :: any)

				CallingCheck.debUNC = true
				Called = true

				pcall(setfenv, 3, OriginalENV)

				return Old(...)
			end

			local StartTime = tick()
			while not Called and tick() - StartTime < 2 do task.wait() end

			assert(Called, "it takes too long to respond")
			assert(SecureGET, "VERY BADLY implemented, tries to do .script (dtc)")
			assert(not LastError, LastError)
		end,
	},

	isnetworkowner = {
		Test = function()
			local isnetworkowner = getfenv().isnetworkowner

			assert(isnetworkowner(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart) == true, "should return true on the hrp")
		end,
		DisabledFor = {"Velocity"} -- keep making it crash veloshitty
	},

	replicatesignal = {
		Test = function()
			local replicatesignal: (Signal: RBXScriptSignal) -> () = getfenv().replicatesignal

			local Player = game:GetService("Players").LocalPlayer

			local Fired = false

			Player.Character.Humanoid.HealthChanged:Once(function()
				Fired = true
			end)

			replicatesignal(Player.Kill)

			local Start = tick()

			repeat
				task.wait()
			until Fired or tick() - Start > 5

			assert(Fired, "health wasn't changed within 5 seconds")
		end,
		DisableOnDebug = true,
	},

	["debug.getstack"] = {
		Test = function() -- credit to dante
			local debug = getfenv().debug

			local GlobalRandom = math.random()
			local RandomGlobal

			local DumpStack
			DumpStack = function()
				local Success, Result = pcall(debug.getstack, 3, 0)
				assert(not Success, `Expected an error, but got: {Result} (argument 0 shouldn't exist)`)

				local RandomNumber = debug.getstack(2, 1)

				assert(type(RandomNumber) == "number", "did not return a number")
				assert(debug.getstack(2)[1] == RandomNumber, "did not return consistent values")
				assert(RandomNumber - GlobalRandom == 5, "returned an unexpected number")

				local NilLocal = table.pack(debug.getstack(2, 2))
				assert(NilLocal[1] == nil, `returned value at index 2: {NilLocal[1]} (expected nil)`)
				assert(NilLocal.n == 1, `returned {NilLocal.n} values at index 2 (expected 1)`)

				local ActualFunc = debug.getstack(2, 3)
				assert(ActualFunc ~= "upvalue", "Unexpected upvalue detected (RandomGlobal treated as local)")
				assert(ActualFunc == DumpStack, `Expected DumpStack, but got: {ActualFunc}`)

				local Success2, Result2 = pcall(debug.getstack, 3, 4) -- pcall adds one stack level
				assert(not Success2, `Expected an error, but got: {Result2} (stack level 4 shouldn't exist)`)
			end

			(function()
				local RandomNumber = GlobalRandom + 5
				local Hidden = nil
				RandomGlobal = "upvalue"
				DumpStack()
			end)()
		end,
	},

	["game.HttpGet"] = {
		Test = function()
			local Success, Result = pcall(game.HttpGet, game, "https://awqbcduwendewbnzd.aaaaaa")

			assert(
				not Success
					or not Result
					or Result == "",
				"httpgetting a nonexistent website should return an error, nil, or an empty string"
			)

			local Result = game:HttpGet("https://raw.githubusercontent.com/alyssagithub/debUNC/refs/heads/main/debUNC.luau")

			assert(Result:find("debUNC"), "failed to get the code of debUNC")
		end,
	},
	
	identifyexecutor = {
		Test = function()
			local identifyexecutor: () -> (string, string) = getfenv().identifyexecutor

			local Name, Version = identifyexecutor()

			assert(typeof(Name) == "string", "the first returned value, the executor's name, should be a string")

			assert(typeof(Version) == "string", "the second returned value, the executor's version, should be a string")
		end,
	},

	gethwid = {
		Test = function()
			local gethwid: () -> string = getfenv().gethwid

			assert(typeof(gethwid()) == "string", "the returned value (user's hwid/fingerprint) should be a string")
		end,
	},
	
	getrawmetatable = {
		Test = function() -- credit to dante
			local getrawmetatable: (Table: {[any]: any}) -> any = getfenv().getrawmetatable

			local Detector = newproxy(true)
			local DetectorMETA, IndxFunc

			local FakeMETA = {
				__index = function()
					return true
				end,
			}

			do
				DetectorMETA = getmetatable(Detector)

				IndxFunc = (function() 
					return (function() -- Break debug.info Stack 2 and 3
						return error("first debUNC", 2)
					end)()
				end)

				DetectorMETA.__index = IndxFunc
				DetectorMETA.__metatable = FakeMETA
			end

			local RawDetectorMETA = getrawmetatable(Detector)

			assert(RawDetectorMETA == getrawmetatable(Detector), "did not even return 2 times the same thing")
			assert(RawDetectorMETA ~= FakeMETA, "its getmetatable with other name")
			assert(RawDetectorMETA == DetectorMETA, "failed to return original META")
			assert(rawequal(RawDetectorMETA, DetectorMETA), "failed to return original META and tried to fake it")
			assert(not table.isfrozen(RawDetectorMETA), "returned a read-only META")
			assert(IndxFunc == RawDetectorMETA.__index, "didnt return the original __index")

			local NewIndxFunc = `debUNC {math.random()}`
			DetectorMETA.__index = NewIndxFunc

			assert(NewIndxFunc == RawDetectorMETA.__index, `changed __index to {NewIndxFunc} but still returns the old one`)

			local Part1 = Instance.new("Part") :: any
			local Part2 = Instance.new("Part") :: any

			local Part1META = getrawmetatable(Part1)

			assert(Part1META == getrawmetatable(Part2), "did not return the same META for unmodified parts")
			assert(table.isfrozen(Part1META), "returned a non read-only Part META")

			for i, MetaType in {"__index", "__newindex", "__namecall", "__metatable"} do
				assert(Part1META[MetaType], `{MetaType} is not valid in a Part`)
			end

			local __index
			xpcall(function()
				return Part1[{}]
			end, function()
				__index = debug.info(2, "f")
			end)

			assert(Part1META["__index"] == __index, `__index did not give {Part1META["__index"]} instead of {__index} (__index may not be CClosure)`)
		end,
	},
	
	["debug.getinfo"] = {
		Test = function() -- credit to dante
			local getinfo = CheckExist("debug.getinfo")

			local A, B, C = 1, nil, nil
			local Funcs = {
				TestFunc = function(D, E, F, ...)
					return A, B, C
				end,
				IsYieldable = coroutine.isyieldable :: any
			}

			local LuaFuncInfo = getinfo(Funcs.TestFunc)
			local CFuncInfo = getinfo(Funcs.IsYieldable)

			local Checks = {
				source = function(func, source)
					return source == "=" .. debug.info(func, "s")
				end,
				what = function(func, what)
					local line = debug.info(func, "l")
					return ((line == -1 and "C") or "Lua") == what
				end,
				numparams = function(func, numParams)
					local params = debug.info(func, "a")
					return params == numParams
				end,
				func = function(func, actualFunc)
					return func == actualFunc
				end,
				short_src = function(func, shortSrc)
					return shortSrc == debug.info(func, "s")
				end,
				currentline = function(func, currentLine)
					return currentLine == debug.info(func, "l")
				end,
				name = function(func, name)
					return name == debug.info(func, "n")
				end,
				is_vararg = function(func, isVararg)
					local _, varargs = debug.info(func, "a")
					return varargs == (isVararg == 1)
				end,
				nups = function(func, expectedNups)
					local getupvalue = rawget(debug, "getupvalue")
					assert(getupvalue, "Cannot check 'nups': 'debug.getupvalue' is missing.")

					local count = 0
					for i = 1, 10 do
						local success = pcall(getupvalue, func, i)
						if not success then break end
						count += 1
					end

					return expectedNups == count
				end,
			}

			for field, check in pairs(Checks) do
				assert(LuaFuncInfo[field], `Missing field in getinfo: {field}`)
				assert(check(Funcs.TestFunc, LuaFuncInfo[field]), `Mismatch in field '{field}': got '{LuaFuncInfo[field]}'`)
				assert(check(Funcs.IsYieldable, CFuncInfo[field]), `Mismatch in C function field '{field}': got '{CFuncInfo[field]}'`)
			end

			for field in pairs(LuaFuncInfo) do
				assert(Checks[field], `no test defined for '{field}'.`)
			end
		end,
	},
}

local NoTests: {[string | number]: any} = {
	"mouse1click",
	"mouse1press",
	"mouse1release",
	"mouse2click",
	"mouse2press",
	"mouse2release",
	"mousemoveabs",
	"mousemoverel",
	"mousescroll",
	"keypress",
	"keyrelease",
	"setclipboard",
	"queueonteleport",
	"setreadonly",
	"sethiddenproperty",
	"setscriptable",
	"setthreadidentity",
	"setstack",
	"setrenderproperty",
	"restorefunction",
	"runonactor",
	"makewriteable",
	"filtergc",
	"runonthread",
	"setrbxclipboard",
	"getsenv",
	"getmenv",
	"setfflag",
	"Drawing.new",
	"isrenderobj",
	"getrenderproperty",
	"cleardrawcache",
	"crypt.hash",
	"crypt.generatebytes",
	"crypt.encrypt",
	"crypt.generatekey",
	"debug.getupvalues",
	"debug.getupvalue",
	"debug.setstack",
	"debug.setupvalue",
	"debug.setconstant",
	"rconsoleinfo",
	"rconsoleerr",
	"rconsoledestroy",
	"rconsolewarn",
	"rconsoleprint",
	"rconsolecreate",

	-- Short Tests
	gethiddenproperty = {Parameters = {game:GetService("Players").LocalPlayer, "SimulationRadius"}, ReturnType = "number"},
	["debug.getregistry"] = {ReturnType = "table"},
	gethui = {ReturnType = "Instance"},
	isrbxactive = {ReturnType = "boolean"},
	iswindowactive = {ReturnType = "boolean"},
	getgc = {ReturnType = "table"},
	getthreadidentity = {ReturnType = "number"},
	comparefunctions = {Parameters = {wait, wait}, ReturnType = "boolean"},
	isexecutorclosure = {Parameters = {wait}, ReturnType = "boolean"},
	islclosure = {Parameters = {wait}, ReturnType = "boolean"},
	["debug.getconstants"] = {Parameters = {function()end}, ReturnType = "table"},
	["debug.getconstant"] = {Parameters = {function()local a; a = "hi"end, 1 :: any}, ReturnType = "string"},
	decompile = {Parameters = {game:FindFirstChildWhichIsA("LuaSourceContainer", true)}, ReturnType = "string"},
	getscriptbytecode = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	getinstances = {ReturnType = "table"},
	getscripthash = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	getscriptclosure = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "function"},
	checkparallel = {ReturnType = "boolean"},
	getfflag = {Parameters = {"MaxFrameBufferSize"}, ReturnType = "string"},
	isnewcclosure = {Parameters = {function()end}, ReturnType = "boolean"},
	getnilinstances = {ReturnType = "table"},
	getrunningscripts = {ReturnType = "table"},
	isparallel = {ReturnType = "boolean"},
	getactors = {ReturnType = "table"},
	getfunctionhash = {Parameters = {function()end}, ReturnType = "string"},
	getactorthreads = {ReturnType = "table"},
}

for Index, Info in NoTests do
	assert(not Tests[Index] and not Tests[Info], `A test for {Index} or {Info} already exists.`)

	if typeof(Index) == "string" then
		Tests[Index] = Info
	else
		Tests[Info] = {}
	end
end

local getgenv: () -> {[string]: any} = getfenv().getgenv or function() return {} end

local function RestoreFunctions()
	if not getgenv().OriginalFunctions then
		return
	end

	for Name, Function in getgenv().OriginalFunctions do
		getfenv()[Name] = Function
	end

	for Name in getgenv().NonExistentFunctions do
		getfenv()[Name] = nil
	end

	getgenv().OriginalFunctions = nil
end

RestoreFunctions()

local identifyexecutor = getfenv().identifyexecutor or function() return "Unknown Executor", "0.0.0" end
local getexecutorname = getfenv().getexecutorname

local ExecutorName, ExecutorVersion = identifyexecutor()

if not ExecutorName then
	ExecutorName = "Unknown Executor"
end

if not ExecutorVersion then
	ExecutorVersion = "0.0.0"
end

local TestService = game:GetService("TestService")

local EndTime = 0

local function DisplayMessage(MessageToDisplay)
	local DisplayFunction: (any?) -> ()

	if ExecutorName == "AWP" then
		DisplayFunction = print
	else
		DisplayFunction = function(Message)
			TestService:Message(Message)
		end
	end

	DisplayFunction(MessageToDisplay)
end

local Settings: {[string]: any} = {
	FakeFunctions = false,
	GetTests = false,
	GetUnaddedFunctions = true,
	DebugMode = false
}

for Name: string, Enabled: boolean in Settings do
	local Saved = getgenv()[Name]

	if Saved ~= nil then
		Settings[Name] = Saved
	end
end

if Settings.FakeFunctions then
	local newcclosure: ((...any) -> ...any) -> (...any) -> ...any = getfenv().newcclosure

	DisplayMessage("[debUNC]: Faking functions is enabled")

	local OriginalFunctions = {}
	local NonExistentFunctions = {}

	for FunctionName in Tests do
		if FunctionName == "getgenv" or FunctionName == "getfenv" or FunctionName == "newcclosure" then
			continue
		end

		if not getfenv()[FunctionName] then
			NonExistentFunctions[FunctionName] = true
		end

		OriginalFunctions[FunctionName] = getfenv()[FunctionName]
		getfenv()[FunctionName] = newcclosure(function()end)
	end

	getgenv().OriginalFunctions = OriginalFunctions
	getgenv().NonExistentFunctions = NonExistentFunctions
end

if Settings.DebugMode then
	DisplayMessage("Debug Mode is enabled!")
end

local getrenv = getfenv().getrenv

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0
local MissingFunctions = 0

local isfunctionhooked = getfenv().isfunctionhooked

if isfunctionhooked then
	assert(isfunctionhooked(pcall) == false, "tests cannot run if pcall is hooked")

	assert(isfunctionhooked(loadstring) == false, "tests cannot run if loadstring is hooked")
end

for Name: string, Info in Tests do
	local function RunTest()
		local Success, ErrorMessage = pcall(function()
			assert(not (Settings.DebugMode and Info.DisableOnDebug), "this function is disabled in debug mode")

			local Function = FindFirstFunction(Name)

			assert(Function, "doesn't exist")
			assert(typeof(Function) == "function", "doesn't have 'function' type")

			if isfunctionhooked then
				assert(isfunctionhooked(Function) == false, "function is hooked and cannot be accurately tested")
			end

			local Info = Info

			do
				local DisabledFor = Info.DisabledFor

				assert(not DisabledFor or not table.find(DisabledFor, ExecutorName), `disabled for {ExecutorName}, most likely due to crashes`)
			end

			if Info.ReturnType then
				CheckReturnType(Function(table.unpack(Info.Parameters or {})), Info.ReturnType)
			end

			if Info.Test then
				Info.Test()
			end
		end)

		if Success then
			print(`🟢 {Name}`)
			CompletedTests += 1
		else
			if not Settings.DebugMode then
				ErrorMessage = ErrorMessage:gsub(".*:%d+: ", "")
			end

			if ErrorMessage:match("doesn't exist") then
				warn(`🟡 {Name}`)
				MissingFunctions += 1
			else
				warn(`🔴 {Name}: {ErrorMessage}`)
				FailedTests += 1
			end
		end

		TotalTests += 1
	end

	if Settings.DebugMode then
		RunTest()
	else
		task.spawn(RunTest)
	end

	if Settings.DebugMode then
		task.wait(0.01)
	else
		task.wait()
	end
end

local function GetAllTests()
	local AllTests = 0

	for _ in Tests do
		AllTests += 1
	end

	return AllTests
end

local StartTime = tick()

repeat
	task.wait()
until TotalTests == GetAllTests()

local EndTime = tick() - StartTime

local MinimumSeconds = 0.1

if EndTime < MinimumSeconds then
	DisplayMessage(`❗❗❗❗ This test is most likely faked as it took less than {MinimumSeconds} second(s). ❗❗❗❗`)
end

DisplayMessage(`❓ The score below is only for how many custom functions are supported.`)
DisplayMessage(`🔵 debUNC BETA v2 Score for {ExecutorName} {ExecutorVersion}: {math.floor(CompletedTests / TotalTests * 100)}%`)
DisplayMessage(`🟣 Total tests: {TotalTests} (Took {math.floor(EndTime * 100) / 100} seconds)`)
DisplayMessage(`🟢 Successful tests: {CompletedTests}`)
DisplayMessage(`🔴 Failed tests: {FailedTests}`)
DisplayMessage(`🟡 Missing functions: {MissingFunctions}`)

local function Divider()
	print("---------------------------------------------------------------------------------------------------------")
end

Divider()

print("debUNC getgenv() Settings:")

Divider()

for Name: string, Enabled: boolean in Settings do
	print(`{Name}: {Enabled}`)
end

Divider()

RestoreFunctions()

if not Settings.GetUnaddedFunctions and not Settings.GetTests then
	return
end

print("A list of functions and libraries in getfenv() and getgenv() that isn't added to the test.")

Divider()

local Blacklist = {
	"aunisgay",
	"aunisafemboy",
	"iusets is a skid",
}

local RobloxEnvironment = getrenv and getrenv() or {}

local AlreadyChecked = {}

local Copy = ""

local function GetFromEnv(Environment, GetTests: boolean?, Library: string?)
	for Name: string, Value: any in Environment do
		if Library then
			Name = `{Library}.{Name}`
		end

		if not GetTests then
			if Tests[Name] then
				continue
			end

			if typeof(Value) ~= "function" and typeof(Value) ~= "table" then
				continue
			end

			if not RobloxEnvironment[Name] and FindFirstFunction(Name, RobloxEnvironment) then
				continue
			end

			if AlreadyChecked[Name] then
				continue
			end

			if table.find(Blacklist, Name) then
				continue
			end
		end

		if typeof(Value) == "table" then
			GetFromEnv(Value, Settings.GetTests, Name)
			continue
		end

		AlreadyChecked[Name] = true

		local Message = `"{Name}",`

		Copy ..= `{Message}\n`
		print(Message)
	end
end

if Settings.GetTests then
	GetFromEnv(Tests, true)
else
	GetFromEnv(getfenv())
	GetFromEnv(getgenv())
end

if Copy == "" then
	print("Couldn't find anything, this executor is all caught up.")
end

Divider()

if Copy == "" then
	return
end

local setclipboard = getfenv().setclipboard

if setclipboard then
	setclipboard(Copy)
	print("^ Copied to your clipboard! ^")

	Divider()
end
