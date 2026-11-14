# checkcaller: () -> boolean
Returns whether or not the current function was called by the executor, which is mainly useful inside of hooks.
```lua
print(checkcaller()) --> true
```
# Aliases
| Name |
| :- |
| check_caller |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the caller is the executor. |
# Test requirements
To pass the checkcaller test, the function must:
- Return true when it's called from the executor.
- Return true inside `task.spawn`, after `task.wait()` and inside `pcall` from the executor.
- Return false when it's called from a game script, such as a hooked function that `ControlModule` calls.
