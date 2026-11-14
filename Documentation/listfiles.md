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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the folder. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {string} | An array of paths. |

# Test requirements
To pass the listfiles test, the function must:
- Return a table, even for an empty folder.
- Include files in the folder.
- Include folders in the folder.
- List only the folder's direct children, not files inside its sub-folders.
