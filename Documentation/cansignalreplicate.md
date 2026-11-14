# cansignalreplicate: (Signal: RBXScriptSignal) -> boolean
Returns whether or not a signal can be sent to the server with [replicatesignal](replicatesignal.md).
```lua
print(cansignalreplicate(game.Players.LocalPlayer.Kill)) --> true
print(cansignalreplicate(workspace.ChildAdded)) --> false
```
# Aliases
| Name |
| :- |
| can_signal_replicate |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal) | The signal to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the signal can be replicated. |
# Test requirements
To pass the cansignalreplicate test, the function must:
- Return true for `Player.Kill`.
- Return false for `workspace.ChildAdded`.
- Return false for a part's `Touched` event.
