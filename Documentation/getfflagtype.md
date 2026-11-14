# getfflagtype: (Flag: string) -> string
Returns the type of value a FastFlag holds, like `bool` or `int`.
```lua
print(getfflagtype("TaskSchedulerTargetFps")) --> int
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Flag: [string](https://create.roblox.com/docs/luau/strings) | The name of the flag. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The flag's type, like `bool`, `int` or `string`. |
# Test requirements
To pass the getfflagtype test, the function must:
- Return `bool` for a flag that's true or false, like `DebugGraphicsPreferVulkan`.
- Return `int` for a flag that holds a number, like `TaskSchedulerTargetFps`.
