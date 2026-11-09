# identifyexecutor: () -> (string, string)
Returns the name and version of the executor.
```lua
local Name, Version = identifyexecutor()
print(Name, Version)
```
# Aliases
| Name |
| :- |
| identify_executor |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The executor's name.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The executor's version. |
# Test requirements
To pass the identifyexecutor test, the function must:
- Return the executor's name as a string.
- Return the executor's version as a second string.
- Return a name that isn't empty.
- Return a version that has a number in it.
- Return the real version of each release, not a fixed placeholder that never changes.
