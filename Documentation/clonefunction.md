# clonefunction: (Function: function) -> function
Creates a copy of a function that keeps its environment and can be called separately from the original.
```lua
local function Greet()
	return "Hello world!"
end

local Clone = clonefunction(Greet)
print(Clone == Greet) --> false
print(Clone()) --> Hello world!
```
# Aliases
| Name |
| :- |
| clone_closure |
| clone_function |
| cloneclosure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to copy.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The copied function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
