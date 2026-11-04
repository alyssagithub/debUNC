# cleardrawcache: () -> ()
Removes every object made with [Drawing.new](Drawing/new.md).
```lua
local Line = Drawing.new("Line")
cleardrawcache()
print(Line.__OBJECT_EXISTS) --> false
```
# Aliases
| Library | Name |
| :- | :- |
| | clear_draw_cache |
