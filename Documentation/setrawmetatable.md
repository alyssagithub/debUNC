# setrawmetatable: (Object: any, Metatable: table) -> ()
Sets the metatable of an object, even if it's locked.
```lua
local Proxy = newproxy()
local Metatable = {}
setrawmetatable(Proxy, Metatable)
print(getmetatable(Proxy) == Metatable) --> true
```
# Aliases
| Name |
| :- |
| set_raw_metatable |
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Metatable: [table](https://create.roblox.com/docs/luau/tables) | The new metatable. |
