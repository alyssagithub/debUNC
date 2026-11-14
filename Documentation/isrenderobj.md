# isrenderobj: (Object: any) -> boolean
Returns whether or not a value is a Drawing object.
```lua
print(isrenderobj(Drawing.new("Line"))) --> true
print(isrenderobj({})) --> false
```
# Aliases
| Name |
| :- |
| is_render_obj |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: any | The value to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's a Drawing object. |

# Test requirements
To pass the isrenderobj test, the function must:
- Return `true` for a drawing object made with [Drawing.new](Drawing/new.md).
- Return `false` for a value that isn't a drawing object, like a table, an Instance, or a number.
