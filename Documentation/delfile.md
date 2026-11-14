# delfile: (Path: string) -> ()
Deletes a file in the workspace folder.
```lua
writefile("Log.txt", "Hello world!")
delfile("Log.txt")
print(isfile("Log.txt")) --> false
```
# Aliases
| Name |
| :- |
| del_file |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |

# Test requirements
To pass the delfile test, the function must:
- Delete the file, so [isfile](isfile.md) returns `false` for it afterward.
- Leave other files and their contents alone.
