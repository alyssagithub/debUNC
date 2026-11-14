# replicatesignal: (Signal: RBXScriptSignal, ...: any) -> ()
Fires a signal on the server, and errors if the signal can't be replicated.
```lua
replicatesignal(game.Players.LocalPlayer.Kill)
```
# Aliases
| Name |
| :- |
| replicate_signal |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to fire. |
| ...: any | The values to fire it with. |

# Test requirements
To pass the replicatesignal test, the function must:
- Error when it's given a signal that can't be replicated, such as `workspace.ChildAdded`.
- Replicate `Player.Kill` to the server, so the player's character dies within 5 seconds and respawns.
