# debug.getcallstack: () -> {{func: function, currentline: number}}
Returns the functions that are currently running, which is known as the call stack.
```lua
local function Greet()
	return debug.getcallstack()
end

local CallStack = Greet()
print(CallStack[1].func == Greet) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_callstack |
| | get_callstack |
| | getcallstack |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;currentline: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre> | An array of the running functions, starting with the current one. |
# Test requirements
To pass the debug.getcallstack test, the function must:
- Return a table.
- List the running functions in order, with the innermost function first.
- Include a `currentline` number in the entry for the calling function.
