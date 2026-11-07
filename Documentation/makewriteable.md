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
