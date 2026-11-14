# raknet.addreceivehook: (Hook: (Packet: Packet) -> ()) -> (Packet: Packet) -> ()
Runs a function on packets the client receives. Call the [Packet](Packet.md)'s Block method to block it.
```lua
local function OnReceive(Packet)
	print(Packet.PacketId, Packet.Size)
end

raknet.addreceivehook(OnReceive)
```
# Aliases
| Library | Name |
| :- | :- |
| raknet | add_receive_hook |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (Packet: [Packet](Packet.md)) -> () | The function to run on each packet. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| (Packet: [Packet](Packet.md)) -> () | The same function that was given. |

# Test requirements
To pass the raknet.addreceivehook test, the function must:
- Call the hook for an incoming packet within 3 seconds.
- Pass a packet whose `PacketId` is a number.
- Pass a packet whose `Size`, `AsString`, and `AsBuffer` all match each other.
