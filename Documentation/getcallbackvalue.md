# getcallbackvalue: (Object: Instance, Callback: string) -> function?
Returns the function assigned to a callback, which Roblox doesn't let you read normally.
```lua
local BindableFunction = Instance.new("BindableFunction")

BindableFunction.OnInvoke = function()
	return "Hello world!"
end

print(getcallbackvalue(BindableFunction, "OnInvoke")()) --> Hello world!
```
# Aliases
| Name |
| :- |
| get_callback_member |
| get_callback_value |
| getcallbackmember |
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance with the callback.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Callback: [string](https://create.roblox.com/docs/luau/strings) | The name of the callback. |
# Returns
| [function?](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The assigned function, or nil if there isn't one.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getcallbackvalue test, the function must:
- Return `nil` when no callback is set.
- Return the callback that was set.
