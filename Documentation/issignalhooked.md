# issignalhooked: (Signal: RBXScriptSignal) -> boolean
Returns whether or not a signal has been hooked with [hooksignal](hooksignal.md).
```lua
local NumberValue = Instance.new("NumberValue")
print(issignalhooked(NumberValue.Changed)) --> false
```
# Aliases
| Name |
| :- |
| is_signal_hooked |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's hooked.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the issignalhooked test, the function must:
- Return `false` for a signal that isn't hooked.
- Return `true` after the signal is hooked with [hooksignal](hooksignal.md).
