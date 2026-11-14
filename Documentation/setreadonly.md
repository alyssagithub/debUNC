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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Table: [table](https://create.roblox.com/docs/luau/tables) | The table to change. |
| ReadOnly: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it should be read-only. |

# Test requirements
To pass the setreadonly test, the function must:
- Make a frozen table, such as `ColorSequence`, writable when it's given `false`.
- Unfreeze the table, so `table.isfrozen` returns `false`.
- Make the table read-only again when it's given `true`.
- Make a normal table read-only.
- Unlock game's metatable and lock it again.
