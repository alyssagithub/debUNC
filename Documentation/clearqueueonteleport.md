# clearqueueonteleport: () -> ()
Clears the code that was queued with [queueonteleport](queueonteleport.md).
```lua
queueonteleport("print('Teleported!')")
clearqueueonteleport()
```
# Aliases
| Name |
| :- |
| clear_teleport_queue |
| clearteleportqueue |

# Test requirements
To pass the clearqueueonteleport test, the function must:
- Stop code queued before it was called from running after the player teleports, when debUNC is run with `shared.TeleportTests = true`.
