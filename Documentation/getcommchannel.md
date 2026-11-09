# getcommchannel: (ChannelId: number) -> table?
Returns a channel made with [createcommchannel](createcommchannel.md) by its id.
```lua
local ChannelId, Channel = createcommchannel()
print(getcommchannel(ChannelId) == Channel) --> true
```
# Aliases
| Name |
| :- |
| get_comm_channel |
# Parameters
| ChannelId: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The id of the channel.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [table?](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The channel, or nil if it doesn't exist.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getcommchannel test, the function must:
- Return the channel that [createcommchannel](createcommchannel.md) made for its id.
- Return `nil` for a channel that was never made.
- Return the same channel on an Actor, so a message fired there reaches the channel.
- Keep the message, `game`, and a trailing `nil` when they're sent from the Actor, for 3 values in total.
