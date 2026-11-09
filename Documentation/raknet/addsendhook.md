# raknet.addsendhook: (Hook: (Packet: Packet) -> ()) -> (Packet: Packet) -> ()
Runs a function on packets the client sends. Call the [Packet](Packet.md)'s Block method to block it.
```lua
local function OnSend(Packet)
	print(Packet.PacketId, Packet.Size)
end

raknet.addsendhook(OnSend)
```
# Aliases
| Library | Name |
| :- | :- |
| raknet | add_send_hook |
# Parameters
| Hook: (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to run on each packet.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The same function that was given.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the raknet.addsendhook test, the function must:
- Call the hook for an outgoing packet within 3 seconds of adding it.
- Give the hook a packet with a number `PacketId`.
- Give the hook a packet whose `Size`, `AsString`, and `AsBuffer` all match each other.
