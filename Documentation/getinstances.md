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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)} | An array of Instances. |

# Test requirements
To pass the getinstances test, the function must:
- Include a newly made Part.
- Include a Part parented to workspace.
