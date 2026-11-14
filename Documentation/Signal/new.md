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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal | The new signal, with the methods below. |
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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Callback: (...any) -> () | The function to run. It's given the values the signal fired with. |
### Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Connection | A connection with a Disconnect method. |
## Once: (Callback: (...any) -> ()) -> Connection
Runs a function the next time the signal fires.
```lua
Signal:Once(function(Message)
	print(Message)
end)
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Callback: (...any) -> () | The function to run. It's given the values the signal fired with. |
### Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Connection | A connection with a Disconnect method. |
## Wait: () -> ...any
Yields until the signal fires, and returns the values it fired with.
```lua
local Message = Signal:Wait()
print(Message)
```
### Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...any | The values the signal fired with. |
## Fire: (...: any) -> ()
Fires the signal with the given values.
```lua
Signal:Fire("Hello world!")
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...: any | The values to fire it with. |
# Test requirements
To pass the Signal.new test, the function must:
- Pass every value given to `:Fire()` to connected functions.
- Stop calling a connection after `:Disconnect()`.
- Call a `:Once()` connection only one time.
- Return the fired value from `:Wait()`.
