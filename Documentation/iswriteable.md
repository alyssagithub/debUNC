# iswriteable: (Table: table) -> boolean
Returns whether or not a table can be written to.
```lua
print(iswriteable({})) --> true
print(iswriteable(table.freeze({}))) --> false
```
# Aliases
| Name |
| :- |
| is_writable |
| is_write_able |
| iswritable |
# Parameters
| Table: [table](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The table to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it can be written to.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the iswriteable test, the function must:
- Return `true` for a normal table.
- Return `false` for a frozen table.
