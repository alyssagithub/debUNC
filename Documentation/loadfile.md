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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function?](https://create.roblox.com/docs/luau/functions) | The compiled function. |
| [string?](https://create.roblox.com/docs/luau/strings) | The error message if it failed. |

# Test requirements
To pass the loadfile test, the function must:
- Return a function that runs the file's code, passing its arguments through `...` and returning its result.
- Not return a function for a file that doesn't exist.
