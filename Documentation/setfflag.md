# setfflag: (Flag: string, Value: string) -> ()
Changes the value of a FastFlag, which is a setting Roblox uses to control its features. Executors can refuse certain flags.
```lua
setfflag("TaskSchedulerTargetFps", "144")
print(getfflag("TaskSchedulerTargetFps")) --> 144
```
# Aliases
| Name |
| :- |
| set_fflag |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Flag: [string](https://create.roblox.com/docs/luau/strings) | The name of the flag. |
| Value: [string](https://create.roblox.com/docs/luau/strings) | The new value. |

# Test requirements
To pass the setfflag test, the function must:
- Set a fast flag's value, so [getfflag](getfflag.md) returns the new value.
