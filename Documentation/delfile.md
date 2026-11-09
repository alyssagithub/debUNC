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
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the delfile test, the function must:
- Delete the file, so [isfile](isfile.md) returns `false` for it afterward.
