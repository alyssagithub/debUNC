# getfflagtype: (Flag: string) -> string
Returns the type of value a FastFlag holds, like `bool` or `int`.
```lua
print(getfflagtype("TaskSchedulerTargetFps")) --> int
```
# Parameters
| Flag: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The name of the flag.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The flag's type, like `bool`, `int` or `string`.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getfflagtype test, the function must:
- Return `bool` for a flag that's true or false, like `DebugGraphicsPreferVulkan`.
- Return `int` for a flag that holds a number, like `TaskSchedulerTargetFps`.
