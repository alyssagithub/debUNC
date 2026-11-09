# oth.get_root_callback: () -> function
Returns a function from inside of a hook made with [oth.hook](hook.md). Only works inside of the hook.
```lua
local Target = newcclosure(function() end)

oth.hook(Target, function()
	print(oth.get_root_callback())
end)

Target()
```
# Aliases
| Library | Name |
| :- | :- |
| oth | getrootcallback |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the oth.get_root_callback test, the function must:
- Return the original function from `oth.hook` as a function.
- Run the hook on its own thread instead of the calling thread, and return the hook's result to the caller.
- Let the original function from `oth.hook` still return the real result, so `math.ldexp(1, 2)` gives `4`.
- Restore the real result after `oth.unhook`.
- Return `true` from `oth.is_hook_thread` inside a hook and `false` outside of one.
- Return a function from `oth.get_root_callback` inside a hook.
- Return the thread that called the hooked function from `oth.get_original_thread` inside a hook.
- Hook and unhook a function made with [newcclosure](../newcclosure.md), returning the hook's result while hooked and the original result after.
