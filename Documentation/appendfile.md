# appendfile: (Path: string, Data: string) -> ()
Adds text to the end of a file in the workspace folder, creating the file if it doesn't exist.
```lua
writefile("Log.txt", "Hello")
appendfile("Log.txt", " world!")
print(readfile("Log.txt")) --> Hello world!
```
# Aliases
| Name |
| :- |
| append_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to add. |
