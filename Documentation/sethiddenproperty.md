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
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
| Value: any | The new value. |
