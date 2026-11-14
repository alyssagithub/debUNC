# getrenderproperty: (Object: DrawingObject, Property: string) -> any
Returns a property of a Drawing object.
```lua
local Line = Drawing.new("Line")
Line.Thickness = 5
print(getrenderproperty(Line, "Thickness")) --> 5
```
# Aliases
| Name |
| :- |
| get_render_property |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: DrawingObject | The Drawing object. |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| any | The property's value. |
# Test requirements
To pass the getrenderproperty test, the function must:
- Return the current value of a Drawing object's property, such as a Line's `Thickness`.
