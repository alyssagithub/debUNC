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
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the caller is the executor.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the checkcaller test, the function must:
- Return true when it's called from the executor.
- Return false when it's called from a game script, such as a hooked function that `ControlModule` calls.
