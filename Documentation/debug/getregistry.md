# debug.getregistry: () -> {[number]: any}
Returns the Luau registry, which holds internal values like threads.
```lua
local Registry = debug.getregistry()
print(typeof(Registry)) --> table
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_registry |
| | get_reg |
| | get_registry |
| | getreg |
| | getregistry |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[number]: any} | The registry, which holds values like functions, tables and threads. |
# Test requirements
To pass the debug.getregistry test, the function must:
- Return a table.
- Include at least one thread.
