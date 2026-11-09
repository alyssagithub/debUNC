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
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the folder.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the makefolder test, the function must:
- Make a folder that [isfolder](isfolder.md) finds afterward.
- Keep an existing file and its contents when called on that file's path.
