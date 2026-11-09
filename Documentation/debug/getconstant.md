# debug.getconstant: (Function: function, Index: number) -> any
Returns a constant from a function by its index. Constants are the fixed values in its code, like strings and numbers.
```lua
local function Greet()
	print("Hello world!")
end

print(debug.getconstant(Greet, 3)) --> Hello world!
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_constant |
| | get_constant |
| | getconstant |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the constant. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The constant.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the debug.getconstant test, the function must:
- Return the string constant at the index where [debug.getconstants](getconstants.md) lists it.
