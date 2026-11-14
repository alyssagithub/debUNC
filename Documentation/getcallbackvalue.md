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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance with the callback. |
| Callback: [string](https://create.roblox.com/docs/luau/strings) | The name of the callback. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function?](https://create.roblox.com/docs/luau/functions) | The assigned function, or nil if there isn't one. |

# Test requirements
To pass the getcallbackvalue test, the function must:
- Return `nil` when no callback is set.
- Return the callback that was set, and only the newest one after it's replaced.
- Not call the callback while reading it.
- Return `nil` after the callback is cleared.
- Return a callback that's a NewCClosure.
- Return a RemoteFunction's `OnClientInvoke`.
- Return `game.OnClose`, a callback on the DataModel.
- Error for a property that isn't a callback, like `Name`.
