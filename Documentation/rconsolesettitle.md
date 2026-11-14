# rconsolesettitle: (Title: string) -> ()
Changes the title of the executor's console window.
```lua
rconsolecreate()
rconsolesettitle("My script")
```
# Aliases
| Name |
| :- |
| rconsolename |
| consolesettitle |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Title: [string](https://create.roblox.com/docs/luau/strings) | The new title. |

# Test requirements
To pass the rconsolesettitle test, the function must:
- Change the title of a console opened with [rconsolecreate](rconsolecreate.md) without erroring.
