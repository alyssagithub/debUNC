# getscriptthread: (Script: LuaSourceContainer) -> thread
Returns the main thread of a running script.
```lua
local Script = game.Players.LocalPlayer.PlayerScripts:FindFirstChildWhichIsA("LocalScript", true)
print(typeof(getscriptthread(Script))) --> thread
```
# Aliases
| Library | Name |
| :- | :- |
| | get_script_thread |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script's thread.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
