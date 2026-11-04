# isnetworkowner: (Part: BasePart) -> boolean
Returns whether or not the client is simulating a part's physics.
```lua
print(isnetworkowner(game.Players.LocalPlayer.Character.HumanoidRootPart)) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | is_network_owner |
# Parameters
| Part: [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The part to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the client owns the part.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
