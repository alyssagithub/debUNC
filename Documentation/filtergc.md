# filtergc: (Type: string, Options: {Keys: {any}?, Values: {any}?, KeyValuePairs: {[any]: any}?, Metatable: table?, Name: string?, IgnoreExecutor: boolean?}, ReturnOne: boolean?) -> {function | table} | function | table | nil
Searches the garbage collector for functions or tables that match the given options.
```lua
local Marker = {Secret = true}
print(filtergc("table", {Keys = {"Secret"}}, true) == Marker) --> true
```
# Aliases
| Name |
| :- |
| filter_gc |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Type: [string](https://create.roblox.com/docs/luau/strings) | Either table or function. |
| Options: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Keys: {any}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Values: {any}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;KeyValuePairs: {[any]: any}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Metatable: table?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Name: string?,<br>&nbsp;&nbsp;&nbsp;&nbsp;IgnoreExecutor: boolean?,<br>}</pre> | What to search for, such as Keys or Name. |
| ReturnOne: [boolean?](https://create.roblox.com/docs/luau/booleans) | Whether to return the first match only. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {function \| table} \| function \| table \| nil | An array of matches, or the first match. |
# Options
| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Keys: [table?](https://create.roblox.com/docs/luau/tables) | For tables, keys that the table has to have. |
| Values: [table?](https://create.roblox.com/docs/luau/tables) | For tables, values that the table has to have. |
| KeyValuePairs: [table?](https://create.roblox.com/docs/luau/tables) | For tables, keys that the table has to have with those exact values. |
| Metatable: [table?](https://create.roblox.com/docs/luau/tables) | For tables, the metatable that the table has to have. |
| Name: [string?](https://create.roblox.com/docs/luau/strings) | For functions, the name of the function. |
| IgnoreExecutor: [boolean?](https://create.roblox.com/docs/luau/booleans) | For functions, whether to skip functions made by the executor. They're skipped unless this is false. |

# Test requirements
To pass the filtergc test, the function must:
- Find a table by one of its keys, and return just that table when the third argument is `true`.
- Find a table by one of its values.
- Find a table by a key and value pair.
- Find a table by its metatable.
- Return exactly one table when only one table has the given key.
- Find a function by its name.
