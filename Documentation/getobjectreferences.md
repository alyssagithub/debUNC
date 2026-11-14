# getobjectreferences: (Object: any) -> {table | function | thread}
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: any | The object to look for. It can't be a number. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {table \| function \| thread} | An array of what references the object. |
# Test requirements
To pass the getobjectreferences test, the function must:
- Return a table.
- Find the table that holds a given table.
- Leave out a table that doesn't hold it.
- Only return things that really reference it.
