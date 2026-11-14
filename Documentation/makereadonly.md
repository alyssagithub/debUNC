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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Table: [table](https://create.roblox.com/docs/luau/tables) | The table to change. |

# Test requirements
To pass the makereadonly test, the function must:
- Freeze the table.
- Error when something writes to the table afterward.
