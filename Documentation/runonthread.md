# runonthread: (Thread: thread, Code: string) -> ()
Runs code on a thread.
```lua
local Thread = task.spawn(function()
	task.wait(1)
end)

runonthread(Thread, "print('Hello world!')") --> Hello world!
```
# Aliases
| Name |
| :- |
| run_on_thread |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The thread to run on. |
| Code: [string](https://create.roblox.com/docs/luau/strings) | The code to run. |

# Test requirements
To pass the runonthread test, the function must:
- Run the code it's given on the thread within 1 second, not on the thread that called runonthread.
- Run code on a thread made with `coroutine.create`, the same way.
