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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function](https://create.roblox.com/docs/luau/functions) | The script's function. |
# Test requirements
To pass the getscriptclosure test, the function must:
- Return a function for a LocalScript.
- Return a function whose environment's `script` is that LocalScript.
- Return a function for a ModuleScript that gives back a table with the same keys as `require` does when it's called.
