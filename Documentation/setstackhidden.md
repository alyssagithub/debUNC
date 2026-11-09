# setstackhidden: (Function: function, Hidden: boolean) -> ()
Hides a function from the call stack, so `debug.info`, `debug.traceback` and error locations skip over it while it runs. It's useful for hooks that a game checks with `debug.info` to find out what called it.
```lua
local function Inner()
	return debug.info(2, "n")
end

local function Hook()
	return Inner()
end

setstackhidden(Hook, true)
print(Hook() == "Hook") --> false
```
# Aliases
| Name |
| :- |
| sethiddenstack |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to hide or show.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hidden: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether to hide it. |

# Test requirements
To pass the setstackhidden test, the function must:
- Hide the function from `debug.info` stack levels.
- Hide the function from `debug.traceback`.
- Leave out the location in errors raised at the hidden function's level, so the message stays as written.
- Show the function on the stack again when it's given `false`.
