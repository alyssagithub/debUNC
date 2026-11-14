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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {string} | An array of type names. |
# Test requirements
To pass the getsignalarguments test, the function must:
- Return a table.
- Return one argument for a part's `Touched`, typed as `Instance` or `BasePart`.
- Return two arguments for `UserInputService.InputBegan`.
- Return one argument for `workspace.ChildAdded`, typed as `Instance`.
- Return no arguments for `Destroying`.
