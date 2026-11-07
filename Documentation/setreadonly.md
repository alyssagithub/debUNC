# setreadonly: (Table: table, ReadOnly: boolean) -> ()
Sets whether or not a table is read-only.
```lua
local Table = {}
setreadonly(Table, true)
print(table.isfrozen(Table)) --> true
```
# Aliases
| Name |
| :- |
| set_read_only |
# Parameters
| Table: [table](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The table to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ReadOnly: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it should be read-only. |
