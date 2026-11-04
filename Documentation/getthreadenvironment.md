# getthreadenvironment: (Thread: thread) -> {[string]: any}
Returns the environment of a thread.
```lua
local Thread = task.spawn(function()
	task.wait(1)
end)

print(getthreadenvironment(Thread) == getfenv()) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | get_thread_env |
| | gettenv |
| | getthreadenv |
# Parameters
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
