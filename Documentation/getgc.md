# getgc: (IncludeTables: boolean?) -> {any}
Returns the functions tracked by the garbage collector, and tables too if IncludeTables is true.
```lua
local function Greet() end
print(table.find(getgc(), Greet) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_gc |
# Parameters
| IncludeTables: [boolean?](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether to include tables.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of functions. With IncludeTables it also has tables and other values, like CFrames.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getgc test, the function must:
- Return a table.
- Include a newly made function.
- Include a newly made table when the first argument is `true`.
