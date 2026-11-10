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

# Test requirements
To pass the getconnections test, the function must:
- Return a table.
- Return one entry for a signal with one connection.
- Give each connection a `Fire` method.
- Set `Function` to the function that was connected.
- Fire the connection with the values passed to `Fire`.
- Set `Thread` to a thread.
- Set `Enabled` to `true` for an active connection.
- Set `Enabled` to `false` after `Disable` is called.
- Stop the connection from firing after `Disable` is called.
- Set `Enabled` to `true` after `Enable` is called.
- Let the connection fire again after `Enable` is called.
- Stop the connection from firing after `Disconnect` is called.
- Leave a connection out after it's disconnected.
- Include connections made with `Once`.
- Give each connection `Enabled`, `ForeignState` and `LuaConnection` as booleans, and `Function`, `Fire`, `Defer`, `Disconnect`, `Disable` and `Enable` as functions.
