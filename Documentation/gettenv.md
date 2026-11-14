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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)? | The thread to read. Defaults to the current thread. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[string]: any} | The thread's environment. |
# Test requirements
To pass the gettenv test, the function must:
- Return the current thread's environment, the same as `getfenv(0)`, when no thread is given or the current thread is passed.
- Return a table for a given thread.
- Return the same environment for a thread started by the current thread.
- Keep the environment of a thread that already finished.
- Return a game LocalScript's own environment for its thread, with `script` set to that LocalScript and no executor functions in it.
