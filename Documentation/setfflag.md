# setfflag: (Flag: string, Value: string) -> ()
Changes the value of a FastFlag, which is a setting Roblox uses to control its features. Executors can refuse certain flags.
```lua
setfflag("TaskSchedulerTargetFps", "144")
print(getfflag("TaskSchedulerTargetFps")) --> 144
```
# Aliases
| Library | Name |
| :- | :- |
| | set_fflag |
# Parameters
| Flag: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The name of the flag.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Value: [string](https://create.roblox.com/docs/luau/strings) | The new value. |
