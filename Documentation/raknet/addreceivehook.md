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
| Hook: (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to run on each packet.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The same function that was given.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
