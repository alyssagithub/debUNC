# getcommchannel: (ChannelId: number) -> table?
Returns a channel made with [createcommchannel](createcommchannel.md) by its id.
```lua
local ChannelId, Channel = createcommchannel()
print(getcommchannel(ChannelId) == Channel) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | get_comm_channel |
# Parameters
| ChannelId: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The id of the channel.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [table?](https://create.roblox.com/docs/luau/tables)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The channel, or nil if it doesn't exist.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
