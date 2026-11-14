# getcallingscript: () -> Instance?
Returns the script that called the current function, which is mainly useful inside of hooks.
```lua
local Original
Original = hookmetamethod(game, "__namecall", function(...)
	print(getcallingscript())
	return Original(...)
end)
```
# Aliases
| Name |
| :- |
| get_calling_script |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [Instance?](https://create.roblox.com/docs/reference/engine/classes/Instance) | The calling script. |

# Test requirements
To pass the getcallingscript test, the function must:
- Return a script, not `nil`, when it's called from a hooked function.
- Return the script that called the hooked function, so it's inside `PlayerModule` for `BaseCharacterController.GetMoveVector`.
