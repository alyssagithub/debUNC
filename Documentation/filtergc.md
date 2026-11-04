# filtergc: (Type: string, Options: {Keys: {any}?, Name: string?, IgnoreExecutor: boolean?}, ReturnOne: boolean?) -> any
Searches the garbage collector for functions or tables that match the given options.
```lua
local Marker = {Secret = true}
print(filtergc("table", {Keys = {"Secret"}}, true) == Marker) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | filter_gc |
# Parameters
| Type: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Either table or function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Options: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Keys: {any}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Name: string?,<br>&nbsp;&nbsp;&nbsp;&nbsp;IgnoreExecutor: boolean?,<br>}</pre> | What to search for, such as Keys or Name. |
| ReturnOne: [boolean?](https://create.roblox.com/docs/luau/booleans) | Whether to return the first match only. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of matches, or the first match.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Options
| Keys: [table?](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | For tables, keys that the table has to have.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Name: [string?](https://create.roblox.com/docs/luau/strings) | For functions, the name of the function. |
| IgnoreExecutor: [boolean?](https://create.roblox.com/docs/luau/booleans) | For functions, whether to skip functions made by the executor. They're skipped unless this is false. |
