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
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;currentline: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of the running functions, starting with the current one.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
