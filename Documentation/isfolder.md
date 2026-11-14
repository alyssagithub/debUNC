# isfolder: (Path: string) -> boolean
Returns whether or not a folder exists in the workspace folder.
```lua
makefolder("Logs")
print(isfolder("Logs")) --> true
```
# Aliases
| Name |
| :- |
| is_folder |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the folder. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the folder exists. |
# Test requirements
To pass the isfolder test, the function must:
- Return `false` for a folder that doesn't exist.
- Return `true` for a folder after it's made.
- Return `false` for a file.
