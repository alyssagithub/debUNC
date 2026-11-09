# makereadonly: (Table: table) -> ()
Makes a table read-only.
```lua
local Table = {}
makereadonly(Table)
print(table.isfrozen(Table)) --> true
```
# Aliases
| Name |
| :- |
| make_read_only |
# Parameters
| Table: [table](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The table to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the makereadonly test, the function must:
- Freeze the table.
- Error when something writes to the table afterward.
