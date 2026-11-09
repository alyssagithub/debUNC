# getrawmetatable: (Object: any) -> table?
Returns the metatable of an object, even if it's locked.
```lua
local Metatable = getrawmetatable(game)
print(typeof(Metatable.__index)) --> function
```
# Aliases
| Name |
| :- |
| get_raw_metatable |
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [table?](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The metatable.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getrawmetatable test, the function must:
- Return the same metatable every time it's called on the same object.
- Return the real metatable, not the value locked with `__metatable`.
- Return the original table itself, not a copy or a fake.
- Return a writable metatable when the original one isn't frozen.
- Return the original `__index`, and show changes made to the metatable afterward.
- Leave `getmetatable` returning the locked `__metatable` value.
- Return the string metatable, with `string` as its `__index`.
- Return a table for a Vector3.
- Return `nil` for a table with no metatable.
- Return the same read-only metatable for unmodified parts.
- Include `__index`, `__newindex`, `__namecall`, and `__metatable` in a part's metatable.
- Return the same C `__index` function that Roblox runs when a part is indexed.
