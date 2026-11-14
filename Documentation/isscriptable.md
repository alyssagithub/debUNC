# isscriptable: (Object: Instance, Property: string) -> boolean
Returns whether or not a property can be read by scripts.
```lua
print(isscriptable(game, "Parent")) --> true
```
# Aliases
| Name |
| :- |
| is_scriptable |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance with the property. |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's scriptable. |

# Test requirements
To pass the isscriptable test, the function must:
- Return `true` for `game.Parent`.
- Return `false` or error for `Fire.size_xml`, a hidden property.
- Return `false` or error for a property that doesn't exist.
