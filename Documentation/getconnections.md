# getconnections: (Signal: RBXScriptSignal) -> {Connection}
Returns the connections of a signal.
```lua
local NumberValue = Instance.new("NumberValue")
NumberValue.Changed:Connect(print)

local Connection = getconnections(NumberValue.Changed)[1]
print(Connection.Function == print) --> true
Connection:Fire(5) --> 5
Connection:Disconnect()
```
# Aliases
| Name |
| :- |
| get_connections |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[Connection](Connection.md)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of every [Connection](Connection.md) on the signal.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
