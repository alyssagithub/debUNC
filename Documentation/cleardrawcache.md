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
# Test requirements
To pass the cleardrawcache test, the function must:
- Remove every drawing object of every type, so `__OBJECT_EXISTS` is false afterward.
- Leave [Drawing.new](Drawing/new.md) working afterward.
