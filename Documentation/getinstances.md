# getinstances: () -> {Instance}
Returns every Instance, including ones parented to nil.
```lua
local Part = Instance.new("Part")
print(table.find(getinstances(), Part) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_instances |
# Returns
| {[Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of Instances.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getinstances test, the function must:
- Include a newly made Part.
- Include a Part parented to workspace.
