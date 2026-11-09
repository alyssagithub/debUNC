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
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | What the file returned.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the dofile test, the function must:
- Run the file without erroring.
- Return the value the file returns.
- Pass an error from inside the file up to the caller.
- Keep the file's original error message.
