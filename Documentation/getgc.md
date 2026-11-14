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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| IncludeTables: [boolean?](https://create.roblox.com/docs/luau/booleans) | Whether to include tables. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {any} | An array of functions. With IncludeTables it also has tables and other values, like CFrames. |

# Test requirements
To pass the getgc test, the function must:
- Return a table.
- Include a newly made function.
- Include a newly made table when the first argument is `true`.
- Return no tables and no duplicates when the first argument is `false`.
- Not run any metamethods on a userdata it collects.
- Let garbage be collected while its result is held.
- Keep `collectgarbage("count")` and `gcinfo()` within 64 KB of each other.
