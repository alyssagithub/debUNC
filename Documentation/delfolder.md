# delfolder: (Path: string) -> ()
Deletes a folder in the workspace folder and everything inside of it.
```lua
makefolder("Logs")
delfolder("Logs")
print(isfolder("Logs")) --> false
```
# Aliases
| Name |
| :- |
| del_folder |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the folder.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the delfolder test, the function must:
- Delete the folder even when it has files and folders in it, so [isfolder](isfolder.md) returns `false` for it afterward.
- Delete everything inside the folder, including files inside its sub-folders.
- Leave other folders and their files alone.
