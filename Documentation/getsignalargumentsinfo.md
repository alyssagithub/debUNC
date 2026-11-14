# getsignalargumentsinfo: (Signal: RBXScriptSignal) -> {{Name: string, Type: string}}
Returns the names and types of the arguments a signal fires with.
```lua
local Info = getsignalargumentsinfo(Instance.new("Part").Touched)[1]
print(Info.Name, Info.Type) --> otherPart Instance
```
# Aliases
| Name |
| :- |
| get_signal_arguments_info |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre> | An array of the signal's arguments. |
# Test requirements
To pass the getsignalargumentsinfo test, the function must:
- Return a table.
- Return a table for each argument.
- Name the argument of a part's `Touched` as `otherPart`, typed as `Instance` or `BasePart`.
- Return two arguments for `UserInputService.InputBegan`.
- Name the second argument of `InputBegan` as `gameProcessedEvent`.
- Return one argument for `workspace.ChildAdded`, typed as `Instance`.
- Return no arguments for `Destroying`.
