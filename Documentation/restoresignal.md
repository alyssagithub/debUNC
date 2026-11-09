# restoresignal: (Signal: RBXScriptSignal) -> ()
Removes a hook made with [hooksignal](hooksignal.md).
```lua
local NumberValue = Instance.new("NumberValue")
hooksignal(NumberValue.Changed, function() end)
restoresignal(NumberValue.Changed)
```
# Aliases
| Name |
| :- |
| restore_signal |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hooked signal.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the restoresignal test, the function must:
- Stop calling a hook added with [hooksignal](hooksignal.md).
- Keep the signal's own connections firing after it's restored.
