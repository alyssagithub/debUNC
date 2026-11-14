# isexecutorthread: (Thread: thread) -> boolean
Returns whether a thread was made by the executor, and not by one of the game's scripts.
```lua
print(isexecutorthread(coroutine.running())) --> true
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The thread to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether the executor made the thread. |
# Test requirements
To pass the isexecutorthread test, the function must:
- Return true for the thread that's running the executor's code.
- Return true for a thread the executor started with `task.spawn`.
- Return false for a game script's thread, like the Animate script's.
- Error when it's given something that isn't a thread.
