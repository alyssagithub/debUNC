# cache.invalidate: (Object: Instance) -> ()
Removes an Instance from the cache of references, so you get a new reference the next time you get it.
```lua
local Folder = Instance.new("Folder")
local Part = Instance.new("Part", Folder)
cache.invalidate(Folder:FindFirstChild("Part"))
print(rawequal(Part, Folder:FindFirstChild("Part"))) --> false
```
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to remove from the cache.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
