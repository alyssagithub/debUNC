# makewriteable: (Table: table) -> ()
Makes a read-only table writable.
```lua
local Table = table.freeze({})
makewriteable(Table)
print(table.isfrozen(Table)) --> false
```
# Aliases
| Name |
| :- |
| make_writable |
| make_write_able |
| makewritable |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Table: [table](https://create.roblox.com/docs/luau/tables) | The table to change. |

# Test requirements
To pass the makewriteable test, the function must:
- Unfreeze a frozen table.
- Allow writing to the table afterward.
