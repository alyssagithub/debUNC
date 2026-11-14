# getfflag: (Flag: string) -> string
Returns the value of a FastFlag, which is a setting Roblox uses to control its features.
```lua
print(getfflag("TaskSchedulerTargetFps"))
```
# Aliases
| Name |
| :- |
| get_fflag |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Flag: [string](https://create.roblox.com/docs/luau/strings) | The name of the flag. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The flag's value. |

# Test requirements
To pass the getfflag test, the function must:
- Return a string for `MaxFrameBufferSize`.
- Return a value that isn't empty, and is a number for `MaxFrameBufferSize`.
- Error or return `nil` for a flag that doesn't exist.
- Return `true` or `false` for a true or false flag.
