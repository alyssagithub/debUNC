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

# Test requirements
To pass the listfiles test, the function must:
- Return a table, even for an empty folder.
- Include files in the folder.
- Include folders in the folder.
- List only the folder's direct children, not files inside its sub-folders.
