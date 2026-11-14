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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the file exists. |
# Test requirements
To pass the isfile test, the function must:
- Return `true` for a file that exists.
- Return `false` for a file that doesn't exist.
- Return `false` for a folder.
