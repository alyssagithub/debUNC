# getthreadidentity: () -> number
Returns the identity of the current thread, which decides what it's allowed to do.
```lua
setthreadidentity(2)
print(getthreadidentity()) --> 2
```
# Aliases
| Name |
| :- |
| get_identity |
| get_thread_context |
| get_thread_identity |
| getidentity |
| getthreadcontext |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [number](https://create.roblox.com/docs/luau/numbers) | The thread's identity. |
# Test requirements
To pass the getthreadidentity test, the function must:
- Keep the current thread's identity when another thread changes its own.
- Return the identity set with [setthreadidentity](setthreadidentity.md), such as 2.
- Match the identity Roblox's `printidentity()` shows.
