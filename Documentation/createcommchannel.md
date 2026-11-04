# createcommchannel: () -> (number, Channel)
Creates a channel for sending values between Actors and the main script.
```lua
local ChannelId, Channel = createcommchannel()

Channel.Event:Connect(function(Message)
	print(Message) --> Hello world!
end)

runonactor(Actor, `getcommchannel({ChannelId}):Fire("Hello world!")`)
```
# Aliases
| Library | Name |
| :- | :- |
| | create_comm_channel |
# Returns
| [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The id of the channel.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Channel | The channel, with the properties and methods below. |
# Properties
| Event: Signal&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A signal that fires with the values sent through the channel.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Methods
## Fire: (...: any) -> ()
Sends the given values through the channel.
```lua
Channel:Fire("Hello world!")
```
### Parameters
| ...: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The values to send.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
