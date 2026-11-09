# getmetafield: (Object: any, Field: string) -> any
Returns a field from an object's metatable, even if the metatable is locked.
```lua
print(typeof(getmetafield(game, "__namecall"))) --> function
```
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Field: [string](https://create.roblox.com/docs/luau/strings) | The name of the field. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The field's value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getmetafield test, the function must:
- Return the value of a field in a table's metatable, such as a number stored in `__index`.
- Return the `__namecall` function from `game`'s locked metatable.
