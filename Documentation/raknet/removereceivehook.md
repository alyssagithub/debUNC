# raknet.removereceivehook: (Hook: (Packet: Packet) -> ()) -> ()
Removes a hook added with [raknet.addreceivehook](addreceivehook.md).
```lua
local function OnReceive(Packet) end

raknet.addreceivehook(OnReceive)
raknet.removereceivehook(OnReceive)
```
# Aliases
| Library | Name |
| :- | :- |
| raknet | remove_receive_hook |
# Parameters
| Hook: (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to remove.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
