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
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread to run on.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Code: [string](https://create.roblox.com/docs/luau/strings) | The code to run. |

# Test requirements
To pass the runonthread test, the function must:
- Run the code it's given on the thread within 1 second.
- Run code on a thread made with `coroutine.create`.
