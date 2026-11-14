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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The file's contents. |

# Test requirements
To pass the readfile test, the function must:
- Error when the file doesn't exist.
- Return the exact contents written by [writefile](writefile.md), including null characters.
- Return an empty string for an empty file.
