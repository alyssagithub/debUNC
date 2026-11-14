# getscriptthread: (Script: LuaSourceContainer) -> thread
Returns the main thread of a running script.
```lua
local Script = game.Players.LocalPlayer.Character.Animate
print(typeof(getscriptthread(Script))) --> thread
```
# Aliases
| Name |
| :- |
| get_script_thread |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The script's thread. |
# Test requirements
To pass the getscriptthread test, the function must:
- Return a thread for a running LocalScript.
- Return a thread that [getscriptfromthread](getscriptfromthread.md) maps back to that LocalScript.
