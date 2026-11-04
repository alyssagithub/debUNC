# getproperties: (Object: Instance) -> {[string]: any}
Returns the properties of an Instance and their values.
```lua
local Part = Instance.new("Part")
print(getproperties(Part).Size == Part.Size) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | get_properties |
# Parameters
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The properties, with each name set to its value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
