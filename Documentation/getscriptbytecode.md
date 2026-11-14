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
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The script's bytecode. |
# Test requirements
To pass the getscriptbytecode test, the function must:
- Return a string for the PlayerModule.
- Return bytecode that isn't empty, at least 64 bytes long and not starting with a 0 byte.
- Return the same bytecode each time for the same script.
- Return different bytecode for different scripts, such as PlayerModule and CameraModule.
