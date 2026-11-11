# setrawmetatable: (Object: userdata | table, Metatable: table) -> ()
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
| Object: userdata \| table&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Metatable: [table](https://create.roblox.com/docs/luau/tables) | The new metatable. |

# Test requirements
To pass the setrawmetatable test, the function must:
- Set the metatable of an object that has none, such as a new proxy.
- Make the new metatable's metamethods work, so calling the proxy runs `__call` and returns its result.
