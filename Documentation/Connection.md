# Connection
A connection to a signal, as returned by [getconnections](getconnections.md).
```lua
local NumberValue = Instance.new("NumberValue")
NumberValue.Changed:Connect(print)

local Connection = getconnections(NumberValue.Changed)[1]
print(Connection.Enabled) --> true
Connection:Disable()
```
# Properties
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The connection's thread. |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function that's connected. It's nil if ForeignState is true. |
| Enabled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the connection is enabled. |
| Connected: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's still connected. |
| ForeignState: [boolean](https://create.roblox.com/docs/luau/booleans) | If this is true, Function and Thread are nil. |
# Methods
## Fire: (...: any) -> ()
Calls the connection right away with the given values.
```lua
Connection:Fire(5)
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...: any | The values to call it with. |
## Defer: (...: any) -> ()
Calls the connection with the given values, but not right away.
```lua
Connection:Defer(5)
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...: any | The values to call it with. |
## Disable: () -> ()
Stops the connection from firing, and sets Enabled to false.
```lua
Connection:Disable()
```
## Enable: () -> ()
Lets a disabled connection fire again, and sets Enabled to true.
```lua
Connection:Enable()
```
## Disconnect: () -> ()
Removes the connection, and sets Connected to false.
```lua
Connection:Disconnect()
```
