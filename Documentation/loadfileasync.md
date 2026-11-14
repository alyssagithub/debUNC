# loadfileasync: (Path: string) -> function
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Compiles a file in the workspace folder into a function without blocking other scripts.
```lua
writefile("Number.lua", "return 42")
print(loadfileasync("Number.lua")()) --> 42
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function](https://create.roblox.com/docs/luau/functions) | The compiled function. |

# Test requirements
To pass the loadfileasync test, the function must:
- Run in the background instead of blocking the thread that calls it.
- Finish within 5 seconds without erroring.
- Return a function that runs the file's code and returns its result.
