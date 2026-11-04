# gettenv: (Thread: thread) -> {[string]: any}
Returns the environment of a thread.
```lua
local Thread = task.spawn(function()
	task.wait(1)
end)

print(typeof(gettenv(Thread))) --> table
```
# Aliases
| Library | Name |
| :- | :- |
| | get_tenv |
| | get_thread_env |
| | get_thread_environment |
| | getthreadenv |
| | getthreadenvironment |
# Parameters
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
