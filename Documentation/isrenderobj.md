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
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The value to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's a Drawing object.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the isrenderobj test, the function must:
- Return `true` for a drawing object made with [Drawing.new](Drawing/new.md).
- Return `false` for a value that isn't a drawing object, like a table, an Instance, or a number.
