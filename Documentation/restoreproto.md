# restoreproto: (Proto: function) -> ()
Removes a hook made with [hookproto](hookproto.md).
```lua
local function Outer()
	return function() end
end

local Proto = debug.getproto(Outer, 1)
hookproto(Proto, function() end)
restoreproto(Proto)
```
# Aliases
| Name |
| :- |
| restore_proto |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Proto: [function](https://create.roblox.com/docs/luau/functions) | The hooked inner function. |

# Test requirements
To pass the restoreproto test, the function must:
- Unhook a proto hooked with [hookproto](hookproto.md), so [isprotohooked](isprotohooked.md) returns `false` for it.
- Make new closures of the proto return their original result again.
