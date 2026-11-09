# readfile: (Path: string) -> string
Returns the contents of a file in the workspace folder, and errors if it doesn't exist.
```lua
writefile("Log.txt", "Hello world!")
print(readfile("Log.txt")) --> Hello world!
```
# Aliases
| Name |
| :- |
| read_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The file's contents.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the readfile test, the function must:
- Error when the file doesn't exist.
- Return the exact contents written by [writefile](writefile.md), including null characters.
- Return an empty string for an empty file.
