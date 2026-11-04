# getfilesize: (Path: string) -> number
Returns the size of a file in the workspace folder in bytes. It's much faster than `#readfile(Path)` on big files, and errors if the file doesn't exist.
```lua
writefile("Log.txt", "Hello")
print(getfilesize("Log.txt")) --> 5
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The file's size in bytes.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
