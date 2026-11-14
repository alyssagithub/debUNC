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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| First: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The first Instance. |
| Second: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The second Instance. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not they're the same Instance. |
# Test requirements
To pass the compareinstances test, the function must:
- Return false for two different parts.
- Return true for an instance and its [cloneref](cloneref.md) clone.
