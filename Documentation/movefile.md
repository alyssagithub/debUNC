# movefile: (Path: string, NewPath: string) -> ()
Moves a file or folder in the workspace folder.
```lua
makefolder("Logs")
writefile("Log.txt", "Hello world!")
movefile("Log.txt", "Logs/Log.txt")
print(isfile("Logs/Log.txt")) --> true
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The current path.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| NewPath: [string](https://create.roblox.com/docs/luau/strings) | The new path. |
