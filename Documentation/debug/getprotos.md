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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The outer function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of the inner functions. Some executors give a ProtoProxy instead of a normal function, which can still be called.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the debug.getprotos test, the function must:
- Return a table.
- Include every inner function, so a function with 2 inner functions gives 2.
- List the inner functions in the order they're written.
