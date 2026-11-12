# hooksignal: (Signal: RBXScriptSignal, Hook: (Info: {Connection: Connection, Function: function, Index: number}, ...any) -> boolean?) -> ()
Runs a function whenever a signal fires. Return false from it to stop the signal's connections from firing.
```lua
local NumberValue = Instance.new("NumberValue")
NumberValue.Changed:Connect(print)

hooksignal(NumberValue.Changed, function(Info, ...)
	return false
end)

NumberValue.Value = 5
```
# Aliases
| Name |
| :- |
| hook_signal |
# Parameters
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to hook.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (Info: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Connection: Connection,<br>&nbsp;&nbsp;&nbsp;&nbsp;Function: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;Index: number,<br>}</pre>, ...any) -> boolean? | The function to run. It's given the Info below and the signal's values, and returning false stops the connection from firing. |
# Info
| Connection: [Connection](Connection.md)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The connection that's about to fire.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function that's connected. |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The connection's position in the signal, starting at 0. Newer connections come first. |
# Test requirements
To pass the hooksignal test, the function must:
- Call the hook when the signal fires.
- Give the hook the connected function in its Info, and the signal's values.
- Stop the signal's connections from firing when the hook returns `false`.
- Leave the same signal on other instances alone.
- Let the signal's connections fire when the hook returns `true`.
