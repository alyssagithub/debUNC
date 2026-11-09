# createcommchannel: () -> (number, Channel)
Creates a channel for sending values between Actors and the main script.
```lua
local Actor = Instance.new("Actor")
Actor.Parent = workspace

local ChannelId, Channel = createcommchannel()

Channel.Event:Connect(function(Message)
	print(Message) --> Hello world!
end)

runonactor(Actor, `getcommchannel({ChannelId}):Fire("Hello world!")`)
```
# Aliases
| Name |
| :- |
| create_comm_channel |
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
# Test requirements
To pass the createcommchannel test, the function must:
- Return a number id along with the channel.
- Make the channel available through [getcommchannel](getcommchannel.md) with that id.
- Fire the channel's `Event` with a message sent from an Actor.
- Keep the values sent from an Actor, so `game` arrives as the same instance.
- Keep `nil` values sent from an Actor, so all 3 values arrive.
