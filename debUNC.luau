--!strict
-- expected type '{Type}', got '{typeof(Result)}'
local function CheckType(Result: any, Type: string)
	assert(typeof(Result) == Type, `expected type '{Type}', got '{typeof(Result)}'`)
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
			
			CheckType(ThreadEnvironment, "table")

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

			local Success = pcall(listfiles, "???")

			assert(not Success, "expected an error when listing files of a folder that doesn't exist")

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

			local Success, Result = pcall(delfile, "???")

			assert(not Success, "Function should error when attempting to delete a file that does not exist.")

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
			
			CheckType(Result, "table")

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

			assert(isfolder("???") == false, "'isfolder' didn't return false when checking if a non-existent folder existed")

			local FolderName = `Folder_{math.random()}`

			makefolder(FolderName)

			assert(isfolder(FolderName), "failed to find folder after it was made")

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

			assert(not isfolder("???"), "Function returned true when checking if a non-existent folder existed.")

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
			local hookfunction: (FunctionToHook: () -> (), Hook: () -> ()) -> (() -> ()) = getfenv().hookfunction

			local GeneratedResult = math.random()

			local function Test()
				return GeneratedResult
			end

			local OtherGeneratedResult = math.random() + 1

			local Hook = hookfunction(Test, function()
				return OtherGeneratedResult
			end)
			
			CheckType(Hook, "function")

			assert(Hook() == GeneratedResult, "Original function does not return the value it's meant to.")

			assert(Test() == OtherGeneratedResult, "Hooked function does not return the value it's meant to.")
		end
	},

	iscclosure = {
		Test = function()
			local iscclosure: (Function: (any?) -> ()) -> (boolean) = getfenv().iscclosure
			
			assert(iscclosure(assert) == true, "function 'assert' is a c closure")

			assert(not iscclosure(function() end), "A function created in the executor is not written in C.")
		end,
	},

	isluau = {
		Test = function()
			local isluau: () -> boolean = getfenv().isluau
			
			local ThreadIsLuau = isluau()
			
			local VersionIsLuau = _VERSION == "Luau"
			
			assert(ThreadIsLuau == VersionIsLuau, `_VERSION is '{_VERSION}', isluau() gave '{isluau()}'`)
		end,
		ReturnType = "boolean"
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
			
			CheckType(Result, "table")

			local Body = Result.Body

			assert(typeof(Body) == "string", "expected a string from the Body")

			local Decoded = game:GetService("HttpService"):JSONDecode(Body)
			
			CheckType(Decoded, "table")

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

	ismoduleloaded = {
		Test = function()
			local ismoduleloaded: (ModuleScript) -> boolean = getfenv().ismoduleloaded

			local Module = game:FindFirstChildWhichIsA("ModuleScript", true)

			assert(Module, FailedFind("module"))
			
			local Result = ismoduleloaded(Module)
			
			assert(Result == true, `modulescript '{Module}' should be loaded`)
		end
	},

	isnetworkowner = {
		Test = function()
			local isnetworkowner: (BasePart | Model) -> boolean = getfenv().isnetworkowner

			local Success = pcall(isnetworkowner, Instance.new("Model"))

			assert(not Success, "expected error when sending a non-basepart")

			local Player = game:GetService("Players").LocalPlayer

			assert(Player, FailedFind("player"))

			local Character = Player.Character

			assert(Character, FailedFind("character"))

			local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")

			assert(HumanoidRootPart, FailedFind("humanoidrootpart"))
			
			assert(isnetworkowner(HumanoidRootPart) == true, "player should have network ownership over the humanoidrootpart")
			
			assert(isnetworkowner(Instance.new("Part")) == false, "player should not have network ownership over a newly created part")
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

			assert(Module, FailedFind("module"))

			local LoadedModules = getloadedmodules()

			assert(table.find(LoadedModules, Module), `failed to find module '{Module}' in table`)
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
			
			assert(isscriptable(game, "a") == false, "game.a is not a valid property")
		end,
	},
}

local NoTests: {[string | number]: any} = {
	"firetouchinterest",
	"consoleclear",
	"consolecreate",
	"consoledestroy",
	"consoleinput",
	"consoleprint",
	"consolename",
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
	"isreadonly",
	"setreadonly",
	"makereadonly",
	"setrawmetatable",
	"isnewcclosure",
	"hookmetamethod",
	"getnamecallmethod",
	"gethiddenproperties",
	"sethiddenproperty",
	"getcallingscript",
	"setfflag",
	"isfunctionhooked",
	"setscriptable",
	"setthreadidentity",
	"getupvalue",
	"setupvalue",
	"getnilinstances",
	"setstack",
	"checkcaller",
	"setrenderproperty",
	"setconstant",
	"getrunningscripts",
	"isparallel",
	"getactors",
	"getfflag",
	"base64decode",
	"restorefunction",
	"runonactor",
	"getupvalues",
	"messagebox",
	"info",
	"consolehide",
	"consoleinfo",
	"getproperties",
	"consoletop",
	"getscriptfromthread",
	"consolehidden",
	"saveinstance",
	"consoletoggle",
	"runfile",
	"keyclick",
	"consolewarn",
	"clearteleportqueue",
	"makewriteable",
	"consoleshow",
	"consoleerr",
	"keytap",
	"getthreads",
	"inparallel",
	"checkpressedkey",
	"iskeydown",
	"getfunctionhash",
	"filtergc",
	"runonthread",
	"getobjects",
	"getactorthreads",
	"setrbxclipboard",
	"replicatesignal",
	"cansignalreplicate",
	"getreplicablesignals",
	"getdrawobjects",
	"rawset",
	"rawget",
	
	-- Short Tests
	gethiddenproperty = {Parameters = {game:GetService("Players").LocalPlayer, "SimulationRadius"}, ReturnType = "number"},
	identifyexecutor = {ReturnType = "string"},
	gethwid = {ReturnType = "string"},
	getregistry = {ReturnType = "table"},
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
	getproto = {Parameters = {function() end, 1 :: any}, ReturnType = "function"}, 
	getprotos = {Parameters = {function() end}, ReturnType = "table"},
	decompile = {Parameters = {game:FindFirstChildWhichIsA("LuaSourceContainer", true)}, ReturnType = "string"},
	getscriptbytecode = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	lz4compress = {Parameters = {"debunctestinglz4compress"}, ReturnType = "string"},
	lz4decompress = {Parameters = {(getfenv().lz4compress or function()end)("debunctestinglz4compress")}, ReturnType = "string"},
	getsenv = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "table"},
	getinstances = {ReturnType = "table"},
	getmenv = {Parameters = {game:FindFirstChildWhichIsA("ModuleScript", true)}, ReturnType = "table"},
	getscripthash = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "string"},
	getinfo = {Parameters = {""}, ReturnType = "table"},
	getconstants = {Parameters = {function()end}, ReturnType = "table"},
	getconstant = {Parameters = {function()local a; a = "hi"end, 1 :: any}, ReturnType = "string"},
	getscriptclosure = {Parameters = {game:FindFirstChildWhichIsA("LocalScript", true)}, ReturnType = "function"},
	checkparallel = {ReturnType = "boolean"},
	cloneref = {Parameters = {game}, ReturnType = "Instance"},
	getrawmetatable = {Parameters = {game}, ReturnType = "table"},
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
	HideNonExistentFunctions = false,
	GetTests = false,
	GetUnaddedFunctions = false,
	MultithreadTests = true,
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

local TotalTests = 0
local CompletedTests = 0
local FailedTests = 0

for Name: string, Info in Tests do
	TotalTests += 1
	
	local function RunTest()
		local Success, Result = pcall(function()
			local Function = getfenv()[Name]

			assert(Function, "doesn't exist")

			local Closure = debug.info(Function, "s")

			assert(Closure == "[C]", `expected closure to be in [C], got '{Closure}'`)

			local Info = Info

			if Info.ReturnType then
				CheckType(getfenv()[Name](table.unpack(Info.Parameters or {})), Info.ReturnType)
			end

			if Info.Test then
				return Info.Test()
			end
		end)

		if Success then
			CompletedTests += 1
			print(`🟢 {Name}`)
		else
			FailedTests += 1

			Result = Result:gsub(".+:%d+: ", "")

			if Settings.HideNonExistentFunctions and Result == "doesn't exist" then
				return
			end

			warn(`🔴 {Name}: {Result}`)
		end
	end
	
	if Settings.MultithreadTests then
		task.spawn(RunTest)
	else
		RunTest()
	end
end

repeat
	task.wait()
until CompletedTests + FailedTests == TotalTests

DisplayMessage(`❓ The score below is only for how many custom functions are supported.`)
DisplayMessage(`🔵 debUNC BETA v2 Score for {ExecutorName} {ExecutorVersion}: {math.floor(CompletedTests / TotalTests * 100)}%`)
DisplayMessage(`🟣 Total tests: {TotalTests}`)
DisplayMessage(`🟢 Successful tests: {CompletedTests}`)
DisplayMessage(`🔴 Failed tests: {FailedTests}`)

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

print("For development purposes, a list of functions in getfenv() and getgenv() that isn't added to the test.")

Divider()

local getrenv = getfenv().getrenv
local RobloxEnvironment = getrenv and getrenv() or {}

local AlreadyChecked = {}

local Copy = ""

local function GetFromEnv(Environment, GetTests: boolean?)
	for Name: string, Value: any in Environment do
		if not GetTests then
			if Tests[Name] then
				continue
			end

			if typeof(Value) ~= "function" then
				continue
			end

			if RobloxEnvironment[Name] then
				continue
			end

			if AlreadyChecked[Name] then
				continue
			end
		end
		
		AlreadyChecked[Name] = true
		
		Copy ..= `"{Name}",\n`
	end
end

if Settings.GetTests then
	GetFromEnv(Tests, true)
else
	GetFromEnv(getfenv())
	GetFromEnv(getgenv())
end

print(Copy)

Divider()

local setclipboard = getfenv().setclipboard

if setclipboard then
	setclipboard(Copy)
	print("^ Copied to your clipboard! ^")
	
	Divider()
end
