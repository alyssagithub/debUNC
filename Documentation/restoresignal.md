# restoresignal: (Signal: RBXScriptSignal) -> ()
Removes a hook made with [hooksignal](hooksignal.md).
```lua
local NumberValue = Instance.new("NumberValue")
hooksignal(NumberValue.Changed, function() end)
restoresignal(NumberValue.Changed)
```
# Aliases
| Library | Name |
| :- | :- |
| | restore_signal |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hooked signal.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
