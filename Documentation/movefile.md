# movefile: (Path: string, NewPath: string) -> ()
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Moves a file or folder in the workspace folder.
```lua
makefolder("Logs")
writefile("Log.txt", "Hello world!")
movefile("Log.txt", "Logs/Log.txt")
print(isfile("Logs/Log.txt")) --> true
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The current path. |
| NewPath: [string](https://create.roblox.com/docs/luau/strings) | The new path. |

# Test requirements
To pass the movefile test, the function must:
- Remove the file from its old path.
- Keep the file's text at its new path.
