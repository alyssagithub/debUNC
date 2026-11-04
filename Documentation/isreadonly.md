# isreadonly: (Table: table) -> boolean
Returns whether or not a table is read-only.
```lua
print(isreadonly({})) --> false
print(isreadonly(table.freeze({}))) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | is_read_only |
# Parameters
| Table: [table](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The table to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's read-only.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
