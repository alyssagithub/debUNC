# queueonteleport: (Code: string) -> ()
Queues code to run after the player teleports.
```lua
queueonteleport("print('Teleported!')")
```
# Aliases
| Name |
| :- |
| queue_on_teleport |
| queue_teleport |
| queueteleport |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Code: [string](https://create.roblox.com/docs/luau/strings) | The code to run. |

# Test requirements
To pass the queueonteleport test, the function must:
- Run the queued code after the player teleports, when debUNC is run with `shared.TeleportTests = true`.
