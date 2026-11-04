# cache.replace: (Object: Instance, NewObject: Instance) -> ()
Makes a different Instance show up wherever you would have gotten the first one.
```lua
local Folder = Instance.new("Folder")
local Part = Instance.new("Part", Folder)
local Fire = Instance.new("Fire")
cache.replace(Part, Fire)
print(Folder:FindFirstChildWhichIsA("Instance") == Fire) --> true
```
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to replace.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| NewObject: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to use instead. |
