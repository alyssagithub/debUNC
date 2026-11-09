# getscriptbytecode: (Script: LuaSourceContainer) -> string
Returns the bytecode of a script, which is its compiled code.
```lua
local Bytecode = getscriptbytecode(game.Players.LocalPlayer.PlayerScripts.PlayerModule)
print(#Bytecode)
```
# Aliases
| Name |
| :- |
| get_script_bytecode |
| dumpstring |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script's bytecode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getscriptbytecode test, the function must:
- Return a string for the PlayerModule.
- Return bytecode that isn't empty.
- Return different bytecode for different scripts, such as PlayerModule and CameraModule.
