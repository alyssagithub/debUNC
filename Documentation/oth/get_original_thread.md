# oth.get_original_thread: () -> thread
Returns the thread that called a hook made with [oth.hook](hook.md). Only works inside of the hook.
```lua
local Target = newcclosure(function() end)

oth.hook(Target, function()
	print(oth.get_original_thread())
end)

Target()
```
# Aliases
| Library | Name |
| :- | :- |
| oth | getoriginalthread |
# Returns
| [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread that called the hook.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
