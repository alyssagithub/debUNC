# setscriptable: (Object: Instance, Property: string, Scriptable: boolean) -> ()
Sets whether or not scripts can read a property. Avoid using it on properties Roblox replicates, since that can crash the game.
```lua
local Fire = Instance.new("Fire")
setscriptable(Fire, "size_xml", true)
print(Fire.size_xml) --> 5
setscriptable(Fire, "size_xml", false)
```
# Aliases
| Name |
| :- |
| set_scriptable |
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance with the property.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
| Scriptable: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it should be scriptable. |
