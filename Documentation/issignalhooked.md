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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's hooked. |

# Test requirements
To pass the issignalhooked test, the function must:
- Return `false` for a signal that isn't hooked.
- Return `true` after the signal is hooked with [hooksignal](hooksignal.md).
- Return `false` after the signal is restored with [restoresignal](restoresignal.md).
