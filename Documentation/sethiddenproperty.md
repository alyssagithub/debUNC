# sethiddenproperty: (Object: Instance, Property: string, Value: any) -> ()
Changes the value of a hidden property.
```lua
local Fire = Instance.new("Fire")
sethiddenproperty(Fire, "size_xml", 10)
print(gethiddenproperty(Fire, "size_xml")) --> 10 true
```
# Aliases
| Name |
| :- |
| set_hidden_property |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to change. |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
| Value: any | The new value. |

# Test requirements
To pass the sethiddenproperty test, the function must:
- Set a normal property, such as a part's `Transparency`.
- Set a hidden property, such as `size_xml` on a `Fire`, so [gethiddenproperty](gethiddenproperty.md) returns the new value.
