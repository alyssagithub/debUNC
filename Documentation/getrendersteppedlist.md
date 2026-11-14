# getrendersteppedlist: () -> {{Name: string, Priority: number, Function: function, Thread: thread}}
Returns the functions bound with RunService:BindToRenderStep.
```lua
for _, Entry in getrendersteppedlist() do
	print(Entry.Name, Entry.Priority, Entry.Function)
end
```
# Aliases
| Name |
| :- |
| get_render_stepped_list |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Priority: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Function: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thread: thread,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre> | An array of the bound functions. |
# Test requirements
To pass the getrendersteppedlist test, the function must:
- Include a function bound with `RunService:BindToRenderStep`, with its `Name`.
- Give that entry's `Function` as the bound function.
- Give that entry's `Priority` as the priority it was bound with.
