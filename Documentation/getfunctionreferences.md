# getfunctionreferences: (Function: function) -> {table | function | thread}
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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to look for.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {table \| function \| thread}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of what references the function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
