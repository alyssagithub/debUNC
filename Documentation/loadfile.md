# loadfile: (Path: string) -> (function?, string?)
Compiles a file in the workspace folder into a function.
```lua
writefile("Number.lua", "return 42")
print(loadfile("Number.lua")()) --> 42
```
# Aliases
| Name |
| :- |
| load_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function?](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The compiled function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string?](https://create.roblox.com/docs/luau/strings) | The error message if it failed. |

# Test requirements
To pass the loadfile test, the function must:
- Return a function that runs the file's code, passing its arguments through `...` and returning its result.
