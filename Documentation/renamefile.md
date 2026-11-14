# renamefile: (Path: string, NewPath: string) -> ()
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Renames a file or folder in the workspace folder. It replaces anything already at the new path.
```lua
writefile("Log.txt", "Hello world!")
renamefile("Log.txt", "Old Log.txt")
print(isfile("Old Log.txt")) --> true
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The current path. |
| NewPath: [string](https://create.roblox.com/docs/luau/strings) | The new path. |

# Test requirements
To pass the renamefile test, the function must:
- Remove the file at the old path.
- Keep the file's text at the new path.
