# getnilinstances: () -> {Instance}
Returns every Instance parented to nil.
```lua
local Part = Instance.new("Part")
print(table.find(getnilinstances(), Part) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_nil_instances |
# Returns
| {[Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of Instances.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getnilinstances test, the function must:
- Include a part that's parented to `nil`.
- Leave out a part that's parented to `workspace`.
