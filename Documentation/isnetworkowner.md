# isnetworkowner: (Part: BasePart) -> boolean
Returns whether or not the client is simulating a part's physics.
```lua
print(isnetworkowner(game.Players.LocalPlayer.Character.HumanoidRootPart)) --> true
```
# Aliases
| Name |
| :- |
| is_network_owner |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Part: [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart) | The part to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the client owns the part. |

# Test requirements
To pass the isnetworkowner test, the function must:
- Return `true` for your character's `HumanoidRootPart`.
- Return `false` for an anchored part that the server owns.
