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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [number](https://create.roblox.com/docs/luau/numbers) | The id of the channel. |
| Channel | The channel, with the properties and methods below. |
# Properties
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Event: Signal | A signal that fires with the values sent through the channel. |
# Methods
## Fire: (...: any) -> ()
Sends the given values through the channel.
```lua
Channel:Fire("Hello world!")
```
### Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...: any | The values to send. |
# Test requirements
To pass the createcommchannel test, the function must:
- Return a number id along with the channel.
- Make the channel available through [getcommchannel](getcommchannel.md) with that id.
- Fire the channel's `Event` with a message sent from an Actor.
- Keep the values sent from an Actor, so `game` arrives as the same instance.
- Keep `nil` values sent from an Actor, so all 3 values arrive.
