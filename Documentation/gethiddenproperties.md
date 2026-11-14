# gethiddenproperties: (Object: Instance) -> {[string]: any}
Returns the hidden properties of an Instance and their values.
```lua
for Name, Value in gethiddenproperties(Instance.new("Part")) do
	print(Name, Value)
end
```
# Aliases
| Name |
| :- |
| get_hidden_properties |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[string]: any} | The hidden properties, with each name set to its value. |

# Test requirements
To pass the gethiddenproperties test, the function must:
- Return a table.
- Return at least one property.
- Leave out properties that aren't hidden, like `Size` on a Part.
- Include at least one property that can't be read normally.
- Return the right value for each property, like a Fire's `size_xml` matching its `Size`.
