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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the Instance is cached. |
# Test requirements
To pass the cache.iscached test, the function must:
- Return true for a newly created instance.
- Return false after the instance is removed with [cache.invalidate](invalidate.md).
