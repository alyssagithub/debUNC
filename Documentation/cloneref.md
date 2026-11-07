# cloneref: (Object: Instance) -> Instance
Creates a new reference to an Instance, which acts the same but is a different object from the original.
```lua
local Part = Instance.new("Part")
local Clone = cloneref(Part)
print(rawequal(Part, Clone)) --> false
print(compareinstances(Part, Clone)) --> true
```
# Aliases
| Name |
| :- |
| clone_ref |
| clone_reference |
| clonereference |
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to make a reference to.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The new reference.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
