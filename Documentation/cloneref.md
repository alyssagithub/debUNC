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
# Test requirements
To pass the cloneref test, the function must:
- Return an Instance.
- Return a reference that isn't the same as the original reference.
- Point to the same instance, so changing the original's `Position` also changes the clone's.
- Pass property changes made through the clone, like `Name`, on to the original.
- Keep the original's class, so `ClassName` and `IsA` match.
- Find the original's children through the clone.
- Fire the clone's `Changed` event when the original changes.
- Give the same `LocalPlayer` through a cloned `Players` service.
- Error when given something that isn't an Instance.
- Destroy the original when the clone is destroyed.
