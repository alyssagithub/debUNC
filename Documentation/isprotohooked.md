# isprotohooked: (Proto: function) -> boolean
Returns whether or not a function hooked with [hookproto](hookproto.md) is still hooked.
```lua
local function Outer()
	return function() end
end

local Proto = debug.getproto(Outer, 1)
print(isprotohooked(Proto)) --> false
```
# Aliases
| Name |
| :- |
| is_proto_hooked |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Proto: [function](https://create.roblox.com/docs/luau/functions) | The inner function from debug.getproto. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's hooked. |

# Test requirements
To pass the isprotohooked test, the function must:
- Return `false` for a proto that isn't hooked.
- Return `true` after the proto is hooked with [hookproto](hookproto.md).
- Make new closures made from a hooked proto return the hook's result.
- Return `false` after [restoreproto](restoreproto.md), and make new closures return the original result again.
