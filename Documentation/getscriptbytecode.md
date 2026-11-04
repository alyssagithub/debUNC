# getscriptbytecode: (Script: LuaSourceContainer) -> string
Returns the bytecode of a script, which is its compiled code.
```lua
local Bytecode = getscriptbytecode(game.Players.LocalPlayer.PlayerScripts.PlayerModule)
print(#Bytecode)
```
# Aliases
| Library | Name |
| :- | :- |
| | get_script_bytecode |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script's bytecode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
