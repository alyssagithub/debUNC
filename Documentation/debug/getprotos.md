# debug.getprotos: (Function: function) -> {any}
Returns every function defined inside of another function.
```lua
local function Outer()
	local function Inner() end
end

print(#debug.getprotos(Outer)) --> 1
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_protos |
| | get_protos |
| | getprotos |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The outer function. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {any} | An array of the inner functions. Some executors give a ProtoProxy instead of a normal function, which can still be called. |
# Test requirements
To pass the debug.getprotos test, the function must:
- Return a table.
- Include every inner function, so a function with 2 inner functions gives 2.
- Return only functions in the table.
- List the inner functions in the order they're written.
