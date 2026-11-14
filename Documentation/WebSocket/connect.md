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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Url: [string](https://create.roblox.com/docs/luau/strings) | The url to connect to. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| WebSocket | The socket, with the properties and methods below. |
# Properties
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| OnMessage: Signal | A signal that fires with each message from the server. |
| OnClose: Signal | A signal that fires when the connection closes. |
# Methods
## Send: (Message: string) -> ()
Sends a message to the server.
```lua
Socket:Send("Hello world!")
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Message: [string](https://create.roblox.com/docs/luau/strings) | The message to send. |
## Close: () -> ()
Closes the connection.
```lua
Socket:Close()
```
# Test requirements
To pass the WebSocket.connect test, the function must:
- Send and receive text with non-ASCII characters, so an echo server's reply reaches `OnMessage` unchanged within 5 seconds.
- Fire `OnClose` when `:Close()` is called.
