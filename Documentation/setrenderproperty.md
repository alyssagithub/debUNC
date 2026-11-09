# setrenderproperty: (Object: DrawingObject, Property: string, Value: any) -> ()
Changes a property of a Drawing object.
```lua
local Line = Drawing.new("Line")
setrenderproperty(Line, "Thickness", 5)
print(Line.Thickness) --> 5
```
# Aliases
| Name |
| :- |
| set_render_property |
# Parameters
| Object: DrawingObject&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Drawing object.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Property: [string](https://create.roblox.com/docs/luau/strings) | The name of the property. |
| Value: any | The new value. |

# Test requirements
To pass the setrenderproperty test, the function must:
- Set a property on a drawing object, such as a `Line`'s `Thickness`.
