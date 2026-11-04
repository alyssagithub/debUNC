# getrendersteppedlist: () -> {{Name: string, Priority: number, Function: function, Thread: thread}}
Returns the functions bound with RunService:BindToRenderStep.
```lua
for _, Entry in getrendersteppedlist() do
	print(Entry.Name, Entry.Priority, Entry.Function)
end
```
# Aliases
| Library | Name |
| :- | :- |
| | get_render_stepped_list |
# Returns
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Priority: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Function: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thread: thread,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of the bound functions.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
