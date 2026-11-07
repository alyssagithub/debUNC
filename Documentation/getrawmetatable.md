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
