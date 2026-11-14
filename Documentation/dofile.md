# dofile: (Path: string) -> any
Runs a file in the workspace folder and returns what it returns.
```lua
writefile("Number.lua", "return 42")
print(dofile("Number.lua")) --> 42
```
# Aliases
| Name |
| :- |
| runfile |
| do_file |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| any | What the file returned. |

# Test requirements
To pass the dofile test, the function must:
- Run the file without erroring.
- Return the value the file returns.
- Pass an error from inside the file up to the caller.
- Keep the file's original error message.
