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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The hooked signal. |

# Test requirements
To pass the restoresignal test, the function must:
- Stop calling a hook added with [hooksignal](hooksignal.md).
- Keep the signal's own connections firing after it's restored.
- Make [issignalhooked](issignalhooked.md) return `false` after it's restored.
