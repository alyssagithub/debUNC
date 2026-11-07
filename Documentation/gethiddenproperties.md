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
| Object: [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Instance to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hidden properties, with each name set to its value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
