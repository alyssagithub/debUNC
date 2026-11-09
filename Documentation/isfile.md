# isfile: (Path: string) -> boolean
Returns whether or not a file exists in the workspace folder.
```lua
writefile("Log.txt", "Hello world!")
print(isfile("Log.txt")) --> true
```
# Aliases
| Name |
| :- |
| is_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the file exists.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the isfile test, the function must:
- Return `true` for a file that exists.
- Return `false` for a file that doesn't exist.
- Return `false` for a folder.
