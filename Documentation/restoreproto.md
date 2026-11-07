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
| Proto: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hooked inner function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
