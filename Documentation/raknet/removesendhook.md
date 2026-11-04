# raknet.removesendhook: (Hook: (Packet: Packet) -> ()) -> ()
Removes a hook added with [raknet.addsendhook](addsendhook.md).
```lua
local function OnSend(Packet) end

raknet.addsendhook(OnSend)
raknet.removesendhook(OnSend)
```
# Aliases
| Library | Name |
| :- | :- |
| raknet | remove_send_hook |
# Parameters
| Hook: (Packet: [Packet](Packet.md)) -> ()&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to remove.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
