# dofile: (Path: string) -> any
Runs a file in the workspace folder and returns what it returns.
```lua
writefile("Number.lua", "return 42")
print(dofile("Number.lua")) --> 42
```
# Aliases
| Library | Name |
| :- | :- |
| | do_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | What the file returned.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
