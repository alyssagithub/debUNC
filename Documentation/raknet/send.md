# raknet.send: (Packet: buffer | string) -> ()
Sends a packet to the server.
```lua
raknet.send(buffer.fromstring("Hello world!"))
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Packet: [buffer](https://create.roblox.com/docs/reference/engine/libraries/buffer) \| [string](https://create.roblox.com/docs/luau/strings) | The packet's data. |

# Test requirements
To pass the raknet.send test, the function must:
- Accept a packet as a string or as a buffer.
- Send packets without getting the player disconnected.
