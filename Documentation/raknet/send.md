# raknet.send: (Packet: buffer | string) -> ()
Sends a packet to the server.
```lua
raknet.send(buffer.fromstring("Hello world!"))
```
# Parameters
| Packet: [buffer](https://create.roblox.com/docs/reference/engine/libraries/buffer) \| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The packet's data.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the raknet.send test, the function must:
- Accept a packet as a string or as a buffer.
- Send packets without getting the player disconnected.
