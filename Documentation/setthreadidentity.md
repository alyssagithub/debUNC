# setthreadidentity: (Identity: number) -> ()
Sets the identity of the current thread, which decides what it's allowed to do.
```lua
setthreadidentity(2)
print(getthreadidentity()) --> 2
```
# Aliases
| Name |
| :- |
| set_identity |
| set_thread_context |
| set_thread_identity |
| setidentity |
| setthreadcontext |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Identity: [number](https://create.roblox.com/docs/luau/numbers) | The new identity. |

# Test requirements
To pass the setthreadidentity test, the function must:
- Block access to `CoreGui` at identity 2.
- Allow access to `CoreGui` at identity 8.
- Change only the current thread's identity, leaving other threads as they were.
- Pass the identity on to threads started from the current thread.
- Keep the identity after the thread yields.
- Block RobloxScript and RobloxSecurity members at identity 2, and allow them at identity 8.
- Error when given something that isn't a number, leaving the identity unchanged.
