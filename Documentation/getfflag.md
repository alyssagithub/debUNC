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
| Flag: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The name of the flag.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The flag's value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getfflag test, the function must:
- Return a string for `MaxFrameBufferSize`.
- Return a value that isn't empty.
- Error or return `nil` for a flag that doesn't exist.
