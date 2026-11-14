# isreadonly: (Table: table) -> boolean
Returns whether or not a table is read-only.
```lua
print(isreadonly({})) --> false
print(isreadonly(table.freeze({}))) --> true
```
# Aliases
| Name |
| :- |
| is_read_only |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Table: [table](https://create.roblox.com/docs/luau/tables) | The table to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's read-only. |

# Test requirements
To pass the isreadonly test, the function must:
- Return `false` for a normal table.
- Return `true` for a frozen table.
