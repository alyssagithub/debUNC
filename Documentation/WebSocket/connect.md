# WebSocket.connect: (Url: string) -> WebSocket
Connects to a WebSocket server.
```lua
local Socket = WebSocket.connect("wss://echo.websocket.org")

Socket.OnMessage:Connect(function(Message)
	print(Message)
end)

Socket:Send("Hello world!")
Socket:Close()
```
# Parameters
| Url: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The url to connect to.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| WebSocket&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The socket, with the properties and methods below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Properties
| OnMessage: Signal&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A signal that fires with each message from the server.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| OnClose: Signal | A signal that fires when the connection closes. |
# Methods
## Send: (Message: string) -> ()
Sends a message to the server.
```lua
Socket:Send("Hello world!")
```
### Parameters
| Message: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The message to send.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
## Close: () -> ()
Closes the connection.
```lua
Socket:Close()
```
