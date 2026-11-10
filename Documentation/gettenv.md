# gettenv: (Thread: thread?) -> {[string]: any}
Returns the environment of a thread. With no thread, it returns the current environment, like `getfenv()`.
```lua
local Thread = task.spawn(function()
	task.wait(1)
end)

print(typeof(gettenv(Thread))) --> table
```
# Aliases
| Name |
| :- |
| get_tenv |
| get_thread_env |
| get_thread_environment |
| getthreadenv |
| getthreadenvironment |
# Parameters
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)?&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread to read. Defaults to the current thread.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the gettenv test, the function must:
- Return the current environment, like `getfenv`, when no thread is given.
- Return a table for a given thread.
- Return this script's environment for a thread started by this script.
- Only include globals that `getfenv()` also has.
- Keep the environment of a thread that already finished.
