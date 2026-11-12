# getscriptclosure: (Script: LuaSourceContainer) -> function
Returns a function made from a script's compiled code.
```lua
local Script = game.Players.LocalPlayer.PlayerScripts:FindFirstChildWhichIsA("LocalScript", true)
print(getfenv(getscriptclosure(Script)).script == Script) --> true
```
# Aliases
| Name |
| :- |
| get_script_closure |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script's function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getscriptclosure test, the function must:
- Return a function for a LocalScript.
- Return a function whose environment's `script` is that LocalScript.
- Return a function for a ModuleScript that gives back a table with the same keys as `require` does when it's called.
