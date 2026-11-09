# hasmetatable: (Object: any) -> boolean
Returns whether or not an object has a metatable.
```lua
print(hasmetatable(game)) --> true
print(hasmetatable({})) --> false
```
# Parameters
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it has a metatable.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the hasmetatable test, the function must:
- Return `true` for a table with a metatable.
- Return `false` for a table without a metatable.
- Return `true` for `game`, which has a locked metatable.
