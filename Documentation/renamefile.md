# renamefile: (Path: string, NewPath: string) -> ()
Renames a file or folder in the workspace folder. It replaces anything already at the new path.
```lua
writefile("Log.txt", "Hello world!")
renamefile("Log.txt", "Old Log.txt")
print(isfile("Old Log.txt")) --> true
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The current path.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| NewPath: [string](https://create.roblox.com/docs/luau/strings) | The new path. |

# Test requirements
To pass the renamefile test, the function must:
- Remove the file at the old path.
- Keep the file's text at the new path.
