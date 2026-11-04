# readfile: (Path: string) -> string
Returns the contents of a file in the workspace folder, and errors if it doesn't exist.
```lua
writefile("Log.txt", "Hello world!")
print(readfile("Log.txt")) --> Hello world!
```
# Aliases
| Library | Name |
| :- | :- |
| | read_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The file's contents.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
