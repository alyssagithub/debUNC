--!strict
-- didn't return a {Type}
local function CheckReturnType(Result: any, Type: string)
	assert(typeof(Result) == Type, `didn't return a {Type}`)
end

-- '{FunctionName}' does not exist, and is required for this test
local function CheckExist(FunctionName: string): any
	assert(getfenv()[FunctionName], `'{FunctionName}' does not exist, and is required for this test`)
	return getfenv()[FunctionName]
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
				"workspace"
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

	getfenv = {
		Test = function()
			local Environment = getfenv()
			assert(typeof(Environment) == "table", "Function should return a table.")

			local getgenv: () -> {[string]: any} = CheckExist("getgenv")

			for Name, Value in getgenv() do
				if typeof(Value) ~= "table" and typeof(Value) ~= "function" then
					continue
				end

				assert(Environment[Name], `Missing '{Name}' from the global environment in the function environment.`)
			end
		end,
		ReturnType = "table"
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

			appendfile(FileName, GeneratedResult)

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

	dofile = {
		Test = function()
			local dofile: (Path: string) -> ...any = getfenv().dofile

			local writefile: (Path: string, Data: string) -> () = CheckExist("writefile")

			local FileName = `File_{math.random()}.txt`
			local GeneratedNumber = math.random()

			writefile(FileName, `return \{{GeneratedNumber}\}`)

			local Result = dofile(FileName)

			local delfile: (Path: string) -> () = getfenv().delfile

			if delfile then
				delfile(FileName)
			end
			
			CheckReturnType(Result, "table")

			assert(Result[1] == GeneratedNumber, "Function's table should've contained the test's randomly generated number.")
		end,
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

			return FolderName
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

			return FolderName
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

			return FolderName
		end
	},

	hookfunction = {
		Test = function()
			local hookfunction: (FunctionToHook: (...any) -> (...any), Hook: () -> ()) -> () -> () = getfenv().hookfunction
			local newcclosure: (((...any) -> ...any) -> (...any) -> ...any)? = getfenv().newcclosure
			
			local function HookTest(FunctionToHook, Hook: (...any) -> ...any, ...)
				local Original = hookfunction(FunctionToHook, Hook)
				
				local Test = Hook(...)
				
				assert(FunctionToHook(...) == Test, `{Test} didn't return the expected value`)
				
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
			local fireproximityprompt: (ProximityPrompt) -> () = getfenv().fireproximityprompt

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
	
	loadstring = {
		Test = function()
			local Loaded = loadstring("return 'debunc'")
			
			assert(typeof(Loaded) == "function", `expected return type to be a function, got {typeof(Loaded)}`)
			
			assert(Loaded() == "debunc", "failed to return the expected value")
		end,
	},
	
	getfpscap = {
		Test = function()
			local getfpscap: () -> number = getfenv().getfpscap
			
			local setfpscap: (FPSCap: number) -> () = getfenv().setfpscap
			
			assert(setfpscap, "'setfpscap' doesn't exist and is required for this test")
			
			setfpscap(10)
			
			local Result = getfpscap()
			
			assert(Result == 10, "did not return the same set fps cap")
			
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
			
			assert(isscriptable(game, "SimulationRadius") == false, "game.SimulationRadius is a hidden property, and isn't scriptable")
			
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
		Test = function()
			local hookmetamethod: (Metatable: any, Metamethod: string, Hook: (...any) -> ...any) -> (...any) -> ...any = getfenv().hookmetamethod
			
			local Metatable = setmetatable({}, {__index = function()end})
			
			local Original = hookmetamethod(Metatable, "__index", function() -- hookfunction(getrawmetatable(Metatable).__index, function())
				return "debUNC"
			end)
			
			CheckReturnType(Original, "function")
			
			assert(Metatable.yay == "debUNC", "indexing the metatable failed to return the hooked value")
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
	"setrawmetatable",
	"getnamecallmethod",
	"sethiddenproperty",
	"getcallingscript",
	"setscriptable",
	"setthreadidentity",
	"setstack",
	"setrenderproperty",
	"restorefunction",
	"runonactor",
	"messagebox",
	"saveinstance",
	"keyclick",
	"clearteleportqueue",
	"makewriteable",
	"keytap",
	"filtergc",
	"runonthread",
	"setrbxclipboard",
	"replicatesignal",
	"getsenv",
	"getmenv",
	"setfflag",
	"drawing.new",
	"drawing.clear",
	"drawing.isrenderobj",
	"drawing.getrenderproperty",
	"drawing.getdrawobjects",
	"cache.replace",
	"cache.iscached",
	"cache.invalidate",
	"crypt.hash",
	"crypt.generatebytes",
	"crypt.encrypt",
	"crypt.generatekey",
	"websocket.connect",
	"debug.getstack",
	"debug.getupvalues",
	"debug.getupvalue",
	"debug.setstack",
	"debug.setupvalue",
	"debug.setconstant",
	
	-- Short Tests
	gethiddenproperty = {Parameters = {game:GetService("Players").LocalPlayer, "SimulationRadius"}, ReturnType = "number"},
	identifyexecutor = {ReturnType = "string"},
	gethwid = {ReturnType = "string"},
	["debug.getregistry"] = {ReturnType = "table"},
	gethui = {ReturnType = "Instance"},
	isrbxactive = {ReturnType = "boolean"},
	iswindowactive = {ReturnType = "boolean"},
	getmodules = {ReturnType = "table"},
	getgc = {ReturnType = "table"},
	getsimulationradius = {Parameters = {game}, ReturnType = "number"},
	getthreadidentity = {ReturnType = "number"},
	comparefunctions = {Parameters = {wait, wait}, ReturnType = "boolean"},
	compareinstances = {Parameters = {game, game}, ReturnType = "boolean"},
	isexecutorclosure = {Parameters = {wait}, ReturnType = "boolean"},
	islclosure = {Parameters = {wait}, ReturnType = "boolean"},
	["debug.getproto"] = {Parameters = {function() end, 1 :: any}, ReturnType = "function"},
	["debug.getprotos"] = {Parameters = {function() end}, ReturnType = "table"},
	["debug.getinfo"] = {Parameters = {function()end}, ReturnType = "table"},
	["debug.getconstants"] = {Parameters = {function()end}, ReturnType = "table"},
	["debug.getconstant"] = {Parameters = {function()local a; a = "hi"end, 1 :: any}, ReturnType = "string"},
	decompile = {Parameters = {game:FindFirstChildWhichIsA("LuaSourceContainer", true)}, ReturnType = "string"},
	getscriptbytecode = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	lz4compress = {Parameters = {"debunctestinglz4compress"}, ReturnType = "string"},
	lz4decompress = {Parameters = {(getfenv().lz4compress or function()end)("debunctestinglz4compress")}, ReturnType = "string"},
	getinstances = {ReturnType = "table"},
	getscripthash = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	getscriptclosure = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "function"},
	checkparallel = {ReturnType = "boolean"},
	cloneref = {Parameters = {game}, ReturnType = "Instance"},
	getrawmetatable = {Parameters = {game}, ReturnType = "table"},
	ismoduleloaded = {Parameters = {game:FindFirstChildWhichIsA("ModuleScript", true)}, ReturnType = "boolean"},
	--isnetworkowner = {Parameters = {game:GetService("Players").LocalPlayer.Character.HumanoidRootPart}, ReturnType = "boolean"}, -- crashes velo
	getfflag = {Parameters = {"MaxFrameBufferSize"}, ReturnType = "string"},
	isnewcclosure = {Parameters = {function()end}, ReturnType = "boolean"},
	iskeydown = {Parameters = {"f"}, ReturnType = "boolean"},
	isreadonly = {Parameters = {{}}, ReturnType = "boolean"},
	isfunctionhooked = {Parameters = {function()end}, ReturnType = "boolean"},
	getnilinstances = {ReturnType = "table"},
	gethiddenproperties = {Parameters = {game}, ReturnType = "table"},
	checkcaller = {ReturnType = "boolean"},
	getrunningscripts = {ReturnType = "table"},
	isparallel = {ReturnType = "boolean"},
	getactors = {ReturnType = "table"},
	base64decode = {Parameters = {"ZGVidW5j"}, ReturnType = "string"},
	getproperties = {Parameters = {game}, ReturnType = "table"},
	getthreads = {ReturnType = "table"},
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
	if getgenv().OriginalFunctions then
		for Name, Function in getgenv().OriginalFunctions do
			getfenv()[Name] = Function
		end

		for Name in getgenv().NonExistentFunctions do
			getfenv()[Name] = nil
		end
		
		getgenv().OriginalFunctions = nil
	end
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

local Settings: {[string]: boolean} = {
	FakeFunctions = false,
	GetTests = false,
	GetUnaddedFunctions = true,
	MultithreadTests = true,
	ShowErrorLines = false,
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

if Settings.HideNonExistentFunctions then
	DisplayMessage("[debUNC]: Hide non-existent functions is enabled")
end

if Settings.GetTests then
	DisplayMessage("[debUNC]: Getting all the tests is enabled")
end

local getrenv = getfenv().getrenv

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0
local MissingFunctions = 0

local function FindFirstFunction(Name: string, Environment: {[string]: any}?): any
	local Value = Environment or getfenv()

	while Value ~= nil and Name ~= "" do
		local Library, NewName = string.match(Name, "^([^.]+)%.?(.*)$")
		
		Value = Value[Library or ""]
		Name = NewName or ""
	end

	return Value
end

for Name: string, Info in Tests do
	local function RunTest()
		local Success, Result = pcall(function()
			local Function = FindFirstFunction(Name)

			assert(Function, "doesn't exist")
			assert(typeof(Function) == "function", "doesn't have 'function' type")
			
			local debug = (getrenv and getrenv() and getrenv().debug) or debug
			
			assert(debug and debug.info, "'debug.info' does not exist and is required for all tests")

			local Info = Info

			if Info.ReturnType then
				CheckReturnType(Function(table.unpack(Info.Parameters or {})), Info.ReturnType)
			end

			if Info.Test then
				return Info.Test()
			end
		end)

		if Success then
			print(`🟢 {Name}`)
			CompletedTests += 1
		else
			if not Settings.ShowErrorLines then
				Result = Result:gsub(".+:%d+: ", "")
			end
			
			if Result:match("doesn't exist") then
				warn(`🟡 {Name}`)
				MissingFunctions += 1
			else
				warn(`🔴 {Name}: {Result}`)
				FailedTests += 1
			end
		end
		
		TotalTests += 1
	end
	
	if Settings.MultithreadTests then
		task.spawn(RunTest)
	else
		RunTest()
	end
end

local function GetAllTests()
	local AllTests = 0
	
	for _ in Tests do
		AllTests += 1
	end
	
	return AllTests
end

repeat
	task.wait()
until TotalTests == GetAllTests()

DisplayMessage(`❓ The score below is only for how many custom functions are supported.`)
DisplayMessage(`🔵 debUNC BETA v2 Score for {ExecutorName} {ExecutorVersion}: {math.floor(CompletedTests / TotalTests * 100)}%`)
DisplayMessage(`🟣 Total tests: {TotalTests}`)
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
	"queue_on_teleport",
	"isgameactive",
	"base64.encode",
	"base64.base64_encode",
	"base64.decode",
	"setthreadcontext",
	"toclipboard",
	"getthreadcontext",
	"replacefunction",
	"rconsoleinfo",
	"get_thread_identity",
	"setidentity",
	"httpget",
	"rconsoleerr",
	"dumpstring",
	"getinstancelist",
	"get_hidden_gui",
	"getinfo",
	"getconstant",
	"is_synapse_function",
	"rconsoledestroy",
	"issentinelclosure",
	"executescript",
	"getconstants",
	"getidentity",
	"setnamecallmethod",
	"httppost",
	"run_on_actor",
	"getcustomasset",
	"replaceclosure",
	"is_sirhurt_closure",
	"crypt.base64decode",
	"crypt.base64_decode",
	"crypt.base64encode",
	"crypt.base64.base64_decode",
	"crypt.base64.base64encode",
	"crypt.base64.encode",
	"crypt.base64.base64decode",
	"crypt.base64.base64_encode",
	"crypt.base64.decode",
	"crypt.base64_encode",
	"base64_encode",
	"base64.base64_decode",
	"base64.base64encode",
	"base64.base64decode",
	"http.request",
	"getstack",
	"is_protosmasher_closure",
	"iscustomcclosure",
	"isourclosure",
	"set_thread_context",
	"checkclosure",
	"base64_decode",
	"set_thread_identity",
	"getscriptfunction",
	"rconsolewarn",
	"getprotos",
	"get_actors",
	"rconsoleprint",
	"defersignal",
	"http_request",
	"getproto",
	"bit.bdiv",
	"bit.badd",
	"bit.rshift",
	"bit.band",
	"bit.bor",
	"bit.bnot",
	"bit.bmul",
	"bit.bswap",
	"bit.arshift",
	"bit.tobit",
	"bit.ror",
	"bit.rol",
	"bit.lshift",
	"bit.tohex",
	"bit.bxor",
	"bit.bsub",
	"getexecutorname",
	"rconsolecreate",
	"getreg",
	"get_thread_context",
	"istempleclosure",
	"input.mouse2release",
	"input.keyrelease",
	"input.mousemoveabs",
	"input.keypress",
	"input.mousemoverel",
	"input.mouse2click",
	"input.mouse2press",
	"input.mousescroll",
	"input.mouse1click",
	"input.mouse1release",
	"input.mouse1press",
	"get_actors_threads",
	"getcallbackvalue",
	"consolecreate",
	"consoledestroy",
	"consoleinfo",
	"consoleerr",
	"consolewarn",
	"consoleprint",
	"run_on_thread",
	"cleardrawcache",
	"isrenderobj",
	"Drawing.clear",
	"Drawing.new",
	"getrenderproperty",
	"fixorion",
	"rconsolesettitle",
	"sirhurt_hub_scrun",
	"getallthreads",
	"developerlogfunctioncall",
	"secureinfo",
	"printdeveloperlog",
	"getdeletedactors",
	"deletefile",
	"rconsolename",
	"rightrelease",
	"fixorionlib",
	"emulateSolara",
	"invalidate",
	"iscached",
	"leftpress",
	"rconsoleclear",
	"sirhurt_run_secure",
	"rightpress",
	"disassemble",
	"leftrelease",
	"syn.crypt.encrypt",
	"syn.crypt.base64.encode",
	"syn.crypt.base64.decode",
	"syn.crypt.base64decode",
	"syn.crypt.hash",
	"syn.crypt.base64encode",
	"syn.crypt.generatebytes",
	"syn.crypt.decrypt",
	"syn.crypt.base64_decode",
	"syn.crypt.base64_encode",
	"syn.crypt.generatekey",
	"syn.is_beta",
	"syn.queue_on_teleport",
	"syn.set_thread_identity",
	"syn.get_thread_identity",
	"syn.request",
	"syn.protect_gui",
	"syn.websocket.connect",
	"syn.write_clipboard",
	"getcurrentline",
	"bit.lrotate",
	"bit.replace",
	"bit.byteswap",
	"bit.extract",
	"bit.countrz",
	"bit.rrotate",
	"bit.btest",
	"bit.countlz",
	"isvalidlevel",
	"validlevel",
	"get_deleted_actors",
	"websocket.Connect",
	"WebSocket.Connect",
	"WebSocket.connect",
	"getscriptthread",
	"isclosurehooked",
	"replace",
	"consoleinput",
	"printconsole",
	"sirhurt_run_secure_code",
	"emulateWave",
	"sirhurt_secure_code",
	"emulateJJSploit",
	"makedir",
	"sirhurt_create_secure_function",
	"restoreclosure",
	"consoleclear",
	"gettreg",
	"crypt.decrypt",
	"secureerror",
	"securewarn",
	"secureprint",
	"mousemove",
	"rconsoleinput",
	"isdir",
	"consolesettitle",
	"deletefolder",
	"WebSocket.New",
	"WebSocket.new",
	"cansignalreplicate",
	"inparallel",
	"getupvalue",
	"setupvalue",
	"makereadonly",
	"getupvalues",
	"getscriptfromthread",
	"setconstant",
	"isnetworkowner",
	"getobjects",
	"getregistry",
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
