# oth.hook: (Function: function, Hook: (...any) -> ...any) -> (...any) -> ...any
Replaces a C function with a function that runs on a separate thread, and returns a function that still runs the original.
```lua
local Target = newcclosure(function()
	return "Hello"
end)

local Original = oth.hook(Target, function()
	return "Goodbye"
end)

print(Target()) --> Goodbye
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The C function to hook. |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| (...any) -> ...any | A function that runs the original. Call it from inside of the hook, with the same values you'd give the original. |

# Test requirements
To pass the oth.hook test, the function must:
- Return the original function from `oth.hook` as a function.
- Run the hook on its own thread instead of the calling thread, and return the hook's result to the caller.
- Let the original function from `oth.hook` still return the real result, so `math.ldexp(1, 2)` gives `4`.
- Restore the real result after `oth.unhook`.
- Return `true` from `oth.is_hook_thread` inside a hook and `false` outside of one.
- Return a function from `oth.get_root_callback` inside a hook.
- Return the thread that called the hooked function from `oth.get_original_thread` inside a hook.
- Hook and unhook a function made with [newcclosure](../newcclosure.md), returning the hook's result while hooked and the original result after.
