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
| Proto: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The inner function from debug.getproto.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's hooked.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
