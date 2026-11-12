# getobjectreferences: (Object: any) -> {table | function | thread}
Returns the tables, functions and threads that reference an object. That covers tables holding it as a key or value, including metatables, functions using it as an upvalue, and threads holding it in a local variable. Signal connections aren't included, and the thread making the call can show up in the results.
```lua
local Target = {}
local Holder = {Target}
print(table.find(getobjectreferences(Target), Holder) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_object_references |
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to look for. It can't be a number.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {table \| function \| thread}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of what references the object.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getobjectreferences test, the function must:
- Return a table.
- Find the table that holds a given table.
- Leave out a table that doesn't hold it.
- Only return things that really reference it.
