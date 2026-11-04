# getnilinstances: () -> {Instance}
Returns every Instance parented to nil.
```lua
local Part = Instance.new("Part")
print(table.find(getnilinstances(), Part) ~= nil) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | get_nil_instances |
# Returns
| {[Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of Instances.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
