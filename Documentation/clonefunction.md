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
# Test requirements
To pass the clonefunction test, the function must:
- Return a new function with a different reference from the original.
- Return a clone that gives the same result as the original.
- Copy the original function's environment.
- Keep an earlier clone's environment when the original function's environment changes later.
- Keep the same source, line, name, parameter count, and variadic flag in `debug.info`.
- Return a new reference when it's given a C function.
- Return a working clone of a C function, so a cloned `WaitForChild` finds and returns Terrain.
- Keep a clone working the same after the function it was cloned from gets hooked.
