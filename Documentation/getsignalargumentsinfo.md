# getsignalargumentsinfo: (Signal: RBXScriptSignal) -> {{Name: string, Type: string}}
Returns the names and types of the arguments a signal fires with.
```lua
local Info = getsignalargumentsinfo(Instance.new("Part").Touched)[1]
print(Info.Name, Info.Type) --> otherPart Instance
```
# Aliases
| Library | Name |
| :- | :- |
| | get_signal_arguments_info |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of the signal's arguments.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
