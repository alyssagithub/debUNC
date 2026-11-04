# appendfileasync: (Path: string, Data: string) -> ()
Adds text to the end of a file without blocking other scripts.
```lua
writefile("Log.txt", "Hello")
appendfileasync("Log.txt", " world!")
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to add. |
