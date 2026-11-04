# Signal.new: () -> Signal
Creates a signal that scripts can connect to and fire.
```lua
local Signal = Signal.new()

Signal:Connect(function(Message)
	print(Message) --> Hello world!
end)

Signal:Fire("Hello world!")
```
# Returns
| Signal&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The new signal, with the methods below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Methods
## Connect: (Callback: (...any) -> ()) -> Connection
Runs a function every time the signal fires.
```lua
local Connection = Signal:Connect(function(Message)
	print(Message)
end)

Connection:Disconnect()
```
### Parameters
| Callback: (...any) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to run. It's given the values the signal fired with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
### Returns
| Connection&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A connection with a Disconnect method.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
## Once: (Callback: (...any) -> ()) -> Connection
Runs a function the next time the signal fires.
```lua
Signal:Once(function(Message)
	print(Message)
end)
```
### Parameters
| Callback: (...any) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to run. It's given the values the signal fired with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
### Returns
| Connection&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A connection with a Disconnect method.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
## Wait: () -> ...any
Yields until the signal fires, and returns the values it fired with.
```lua
local Message = Signal:Wait()
print(Message)
```
### Returns
| ...any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The values the signal fired with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
## Fire: (...: any) -> ()
Fires the signal with the given values.
```lua
Signal:Fire("Hello world!")
```
### Parameters
| ...: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The values to fire it with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
