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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (Packet: [Packet](Packet.md)) -> () | The function to remove. |

# Test requirements
To pass the raknet.removereceivehook test, the function must:
- Stop calling a receive hook once it's removed, while other receive hooks keep getting incoming packets.
