# getsignalarguments: (Signal: RBXScriptSignal) -> {string}
Returns the types of the arguments a signal fires with.
```lua
print(getsignalarguments(Instance.new("Part").Touched)[1]) --> Instance
```
# Aliases
| Name |
| :- |
| get_signal_arguments |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {string}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of type names.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getsignalarguments test, the function must:
- Return a table.
- Return one argument for a part's `Touched`, typed as `Instance` or `BasePart`.
- Return two arguments for `UserInputService.InputBegan`.
