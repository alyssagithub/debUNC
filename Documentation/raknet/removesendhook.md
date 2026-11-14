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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Hook: (Packet: [Packet](Packet.md)) -> () | The function to remove. |

# Test requirements
To pass the raknet.removesendhook test, the function must:
- Stop calling a send hook once it's removed, while other send hooks keep getting outgoing packets.
