# readfileasync: (Path: string) -> string
Returns the contents of a file without blocking other scripts.
```lua
writefile("Log.txt", "Hello world!")
print(readfileasync("Log.txt")) --> Hello world!
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The file's contents.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the readfileasync test, the function must:
- Run in the background instead of blocking until it finishes.
- Finish within 5 seconds without erroring.
- Return the file's text.
