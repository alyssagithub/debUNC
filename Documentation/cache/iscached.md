# cache.iscached: (Object: Instance) -> boolean
Returns whether or not an Instance is in the cache of references.
```lua
local Part = Instance.new("Part")
print(cache.iscached(Part)) --> true
cache.invalidate(Part)
print(cache.iscached(Part)) --> false
```
# Aliases
| Library | Name |
| :- | :- |
| cache | is_cached |
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the Instance is cached.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
