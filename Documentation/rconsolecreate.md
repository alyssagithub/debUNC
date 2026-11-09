# rconsolecreate: () -> ()
Opens the executor's console window.
```lua
rconsolecreate()
rconsoleprint("Hello world!")
```
# Aliases
| Name |
| :- |
| console_create |
| consolecreate |
| rconsole_create |

# Test requirements
To pass the rconsolecreate test, the function must:
- Create a console that opens with `rconsoleshow`, so `rconsolehidden` no longer returns `true`.
