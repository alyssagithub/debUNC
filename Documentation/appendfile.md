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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to add. |
# Test requirements
To pass the appendfile test, the function must:
- Add the text to the end of the file without changing what was already in it, including null characters and `\r\n` line endings.
