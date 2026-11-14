# raknet.receive: (Packet: buffer | string) -> ()
Makes the client act as if it received a packet.
```lua
raknet.receive(buffer.fromstring("Hello world!"))
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Packet: [buffer](https://create.roblox.com/docs/reference/engine/libraries/buffer) \| [string](https://create.roblox.com/docs/luau/strings) | The packet's data. |

# Test requirements
To pass the raknet.receive test, the function must:
- Pass the packet it's given to receive hooks within 3 seconds, with the same contents in `AsString`.
