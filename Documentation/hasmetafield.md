# hasmetafield: (Object: any, Field: string) -> boolean
Returns whether or not an object's metatable has a field, even if the metatable is locked.
```lua
print(hasmetafield(game, "__namecall")) --> true
print(hasmetafield(setmetatable({}, {}), "__index")) --> false
```
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Field: [string](https://create.roblox.com/docs/luau/strings) | The name of the field. |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the field exists.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
