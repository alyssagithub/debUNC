# restorefunction: (Function: function) -> ()
Removes a hook made with [hookfunction](hookfunction.md).
```lua
local function Greet()
	return "Hello"
end

hookfunction(Greet, function()
	return "Goodbye"
end)

restorefunction(Greet)
print(Greet()) --> Hello
```
# Aliases
| Name |
| :- |
| restore_func |
| restore_function |
| restorefunc |
| unhook_function |
| unhookfunction |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The hooked function. |
# Test requirements
To pass the restorefunction test, the function must:
- Return the original result after a LuaClosure, NewCClosure, or C function is restored, whether it was hooked with a LuaClosure, NewCClosure, or C function.
- Keep the function's original source after it's restored, so a C function still shows `[C]` in `debug.info`.
- Keep a C function's original error messages after it's restored.
- Remove every hook at once when the function was hooked more than once.
- Allow a restored function to be hooked and restored again.
- Only restore the function it's given.
- Undo a [hookmetamethod](hookmetamethod.md) hook when it's given the original metamethod function.
- Error when it's given something that isn't a function.
