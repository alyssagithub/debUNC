# Packet
The packet given to the hooks from [raknet.addsendhook](addsendhook.md) and [raknet.addreceivehook](addreceivehook.md). A packet only works inside of the hook, so copy anything you need before the hook ends.
```lua
local function OnSend(Packet)
	print(Packet.PacketId, Packet.Size, Packet.AsString)
	Packet:Block()
end

raknet.addsendhook(OnSend)
```
# Properties
| PacketId: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The id of the packet.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Size: [number](https://create.roblox.com/docs/luau/numbers) | The size of the packet in bytes. |
| AsString: [string](https://create.roblox.com/docs/luau/strings) | The packet's data as a string. |
| AsBuffer: [buffer](https://create.roblox.com/docs/reference/engine/libraries/buffer) | The packet's data as a buffer. |
| Id: [number](https://create.roblox.com/docs/luau/numbers) | The same as PacketId. Not every executor has this. |
| Data: [buffer](https://create.roblox.com/docs/reference/engine/libraries/buffer) | The packet's data. Not every executor has this. |
| AsArray: [table](https://create.roblox.com/docs/luau/tables) | The packet's data as an array of bytes. Not every executor has this. |
| Priority: [number](https://create.roblox.com/docs/luau/numbers) | The packet's priority. Not every executor has this. |
| Reliability: [number](https://create.roblox.com/docs/luau/numbers) | How reliably the packet is sent. Not every executor has this. |
| Blocked: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the packet has been blocked. Not every executor has this. |
# Methods
## Block: () -> ()
Stops the packet from going through.
```lua
local function OnSend(Packet)
	Packet:Block()
end

raknet.addsendhook(OnSend)
```
