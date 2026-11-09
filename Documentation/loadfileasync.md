# loadfileasync: (Path: string) -> function
Compiles a file in the workspace folder into a function without blocking other scripts.
```lua
writefile("Number.lua", "return 42")
print(loadfileasync("Number.lua")()) --> 42
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The compiled function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the loadfileasync test, the function must:
- Run in the background instead of blocking the thread that calls it.
- Finish within 5 seconds without erroring.
- Return a function that runs the file's code and returns its result.
