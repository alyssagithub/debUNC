# oth.is_hook_thread: () -> boolean
Returns whether or not the current thread is running a hook made with [oth.hook](hook.md).
```lua
print(oth.is_hook_thread()) --> false
```
# Aliases
| Library | Name |
| :- | :- |
| oth | ishookthread |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's a hook thread. |

# Test requirements
To pass the oth.is_hook_thread test, the function must:
- Return the original function from `oth.hook` as a function.
- Run the hook on its own thread instead of the calling thread, and return the hook's result to the caller.
- Let the original function from `oth.hook` still return the real result, so `math.ldexp(1, 2)` gives `4`.
- Restore the real result after `oth.unhook`.
- Return `true` from `oth.is_hook_thread` inside a hook and `false` outside of one.
- Return a function from `oth.get_root_callback` inside a hook.
- Return the thread that called the hooked function from `oth.get_original_thread` inside a hook.
- Hook and unhook a function made with [newcclosure](../newcclosure.md), returning the hook's result while hooked and the original result after.
