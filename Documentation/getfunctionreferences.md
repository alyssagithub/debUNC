# getfunctionreferences: (Function: function) -> {table | function | thread}
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Returns the tables, functions and threads that reference a function. That covers tables holding it as a key or value, including metatables, functions using it as an upvalue, and threads holding it in a local variable. Signal connections aren't included, and the thread making the call can show up in the results.
```lua
local function Greet() end
local Holder = {Greet}
print(table.find(getfunctionreferences(Greet), Holder) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_function_references |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to look for. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {table \| function \| thread} | An array of what references the function. |

# Test requirements
To pass the getfunctionreferences test, the function must:
- Return a table.
- Include the table that holds the function.
- Leave out a table that doesn't hold it.
- Only return things that really reference it.
