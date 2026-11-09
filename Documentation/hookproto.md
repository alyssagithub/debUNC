# hookproto: (Proto: function, Hook: (...any) -> ...any) -> ()
Replaces a function defined inside of another function, including new copies of it.
```lua
local function Outer()
	return function()
		return "Hello"
	end
end

hookproto(debug.getproto(Outer, 1), function()
	return "Goodbye"
end)

print(Outer()()) --> Goodbye
```
# Aliases
| Name |
| :- |
| hook_proto |
# Parameters
| Proto: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The inner function from debug.getproto.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (...any) -> ...any | The function to run instead. |
# Test requirements
To pass the hookproto test, the function must:
- Make [isprotohooked](isprotohooked.md) return `false` before the proto is hooked.
- Make [isprotohooked](isprotohooked.md) return `true` after the proto is hooked.
- Make new closures made from the proto return the hook's result.
- Make [isprotohooked](isprotohooked.md) return `false` after [restoreproto](restoreproto.md).
- Make new closures return the original result after [restoreproto](restoreproto.md).
