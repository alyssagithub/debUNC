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
| Object: DrawingObject&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Drawing object.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The property's value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getrenderproperty test, the function must:
- Return the current value of a Drawing object's property, such as a Line's `Thickness`.
