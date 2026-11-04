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
| Library | Name |
| :- | :- |
| | restore_func |
| | restore_function |
| | restorefunc |
| | unhook_function |
| | unhookfunction |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hooked function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
