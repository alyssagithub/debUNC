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
| Signal: [RBXScriptSignal](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptSignal)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signal to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the signal can be replicated.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the cansignalreplicate test, the function must:
- Return true for `Player.Kill`.
- Return false for `workspace.ChildAdded`.
- Return false for a part's `Touched` event.
