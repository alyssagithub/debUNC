# getproperties: (Object: Instance) -> {[string]: any}
Returns the properties of an Instance and their values.
```lua
local Part = Instance.new("Part")
print(getproperties(Part).Size == Part.Size) --> true
```
# Aliases
| Name |
| :- |
| get_properties |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance) | The Instance to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[string]: any} | The properties, with each name set to its value. |
# Test requirements
To pass the getproperties test, the function must:
- Return a table.
- Include a part's current `Size`.
- Include a part's `Name`.
- Include a Fire's default `Heat` of 9.
