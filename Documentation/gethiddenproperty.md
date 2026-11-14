# gethiddenproperty: (Object: Instance, Property: string) -> any
Returns the value of a hidden property.
```lua
print(gethiddenproperty(game.Players.LocalPlayer, "SimulationRadius"))
```
# Aliases
| Name |
| :- |
| get_hidden_property |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to read. |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| any | The property's value. |

# Test requirements
To pass the gethiddenproperty test, the function must:
- Return the value of a hidden property, like a Fire's `size_xml` matching its `Size`.
