# makefolder: (Path: string) -> ()
Creates a folder in the workspace folder.
```lua
makefolder("Logs")
print(isfolder("Logs")) --> true
```
# Aliases
| Name |
| :- |
| make_folder |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the folder. |

# Test requirements
To pass the makefolder test, the function must:
- Make a folder that [isfolder](isfolder.md) finds afterward.
- Make a folder inside another folder.
- Keep the files and folders inside a folder when it's called on that folder again.
- Keep an existing file and its contents when called on that file's path.
