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
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The property's value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the gethiddenproperty test, the function must:
- Return the value of a hidden property, like a Fire's `size_xml` matching its `Size`.
