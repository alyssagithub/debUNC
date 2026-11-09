# compareinstances: (First: Instance, Second: Instance) -> boolean
Returns whether or not two references point to the same Instance, even if one was made with [cloneref](cloneref.md).
```lua
local Part = Instance.new("Part")
print(compareinstances(Part, cloneref(Part))) --> true
```
# Aliases
| Name |
| :- |
| compare_instances |
# Parameters
| First: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The first Instance.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Second: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The second Instance. |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not they're the same Instance.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the compareinstances test, the function must:
- Return false for two different parts.
- Return true for an instance and its [cloneref](cloneref.md) clone.
