# writefile: (Path: string, Data: string) -> ()
Writes text to a file in the workspace folder, replacing what's already in it.
```lua
writefile("Log.txt", "Hello world!")
print(readfile("Log.txt")) --> Hello world!
```
# Aliases
| Name |
| :- |
| write_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to write. |
