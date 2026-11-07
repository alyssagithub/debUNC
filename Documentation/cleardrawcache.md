# cleardrawcache: () -> ()
Removes every object made with [Drawing.new](Drawing/new.md).
```lua
local Line = Drawing.new("Line")
cleardrawcache()
print(Line.__OBJECT_EXISTS) --> false
```
# Aliases
| Name |
| :- |
| clear_draw_cache |
