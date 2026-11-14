# isstackhidden: (Function: function) -> boolean
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Returns whether a function was hidden from the call stack with [setstackhidden](setstackhidden.md).
```lua
local function Hook() end

setstackhidden(Hook, true)
print(isstackhidden(Hook)) --> true
```
# Aliases
| Name |
| :- |
| ishiddenstack |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether the function is hidden. |

# Test requirements
To pass the isstackhidden test, the function must:
- Return `false` for a function that isn't hidden.
- Return `true` after the function is hidden with [setstackhidden](setstackhidden.md).
- Keep returning `false` for a different function that was never hidden.
- Return `false` again after the function is shown again.
