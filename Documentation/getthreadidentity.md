# getthreadidentity: () -> number
Returns the identity of the current thread, which decides what it's allowed to do.
```lua
setthreadidentity(2)
print(getthreadidentity()) --> 2
```
# Aliases
| Library | Name |
| :- | :- |
| | get_identity |
| | get_thread_context |
| | get_thread_identity |
| | getidentity |
| | getthreadcontext |
# Returns
| [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread's identity.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
