# isstackhidden: (Function: function) -> boolean
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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether the function is hidden.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
