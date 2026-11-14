# getscriptfromthread: (Thread: thread) -> Instance?
Returns the script that a thread belongs to.
```lua
local Script = game.Players.LocalPlayer.Character.Animate
print(getscriptfromthread(getscriptthread(Script)) == Script) --> true
```
# Aliases
| Name |
| :- |
| get_script_from_thread |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The thread to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [Instance?](https://create.roblox.com/docs/reference/engine/classes/Instance) | The script. |
# Test requirements
To pass the getscriptfromthread test, the function must:
- Return `nil` for a thread that doesn't belong to a script.
- Return the LocalScript that a thread from [getscriptthread](getscriptthread.md) belongs to.
