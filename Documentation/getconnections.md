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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[Connection](Connection.md)} | An array of every [Connection](Connection.md) on the signal. |

# Test requirements
To pass the getconnections test, the function must:
- Return a table.
- Return one entry for each connection on a signal with two connections.
- Give each connection a `Fire` method.
- Set `Function` to the function that was connected.
- Fire only that connection with the values passed to `Fire`.
- Fire the connection when `Defer` is called.
- Set `Thread` to a thread.
- Set `Enabled` to `true` for an active connection.
- Set `Enabled` to `false` after `Disable` is called.
- Stop the connection from firing after `Disable` is called, while the other connection on the signal keeps firing.
- Set `Enabled` to `true` after `Enable` is called.
- Let the connection fire again after `Enable` is called.
- Stop the connection from firing after `Disconnect` is called, while the other connection on the signal keeps firing.
- Leave a connection out after it's disconnected, and keep the other one listed.
- Include connections made with `Once`.
- Give each connection `Enabled`, `ForeignState` and `LuaConnection` as booleans, and `Function`, `Fire`, `Defer`, `Disconnect`, `Disable` and `Enable` as functions.
