# listfiles: (Path: string) -> {string}
Returns the paths of the files and folders directly inside of a folder in the workspace folder. Paths use backslashes, like Logs\Log.txt.
```lua
for _, Path in listfiles("Logs") do
	print(Path)
end
```
# Aliases
| Name |
| :- |
| list_files |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the folder.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {string}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of paths.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
