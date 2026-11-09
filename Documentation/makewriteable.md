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
| Table: [table](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The table to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the makewriteable test, the function must:
- Unfreeze a frozen table.
- Allow writing to the table afterward.
