# firesignal: (Signal: RBXScriptSignal, ...: any) -> ()
Fires the connections of a signal with the given values.
```lua
local NumberValue = Instance.new("NumberValue")

NumberValue.Changed:Connect(function(Value)
	print(Value) --> 5
end)

firesignal(NumberValue.Changed, 5)
```
# Aliases
| Name |
| :- |
| fire_signal |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to fire.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...: any | The values to fire it with. |
