# firetouchinterest: (Part: BasePart, OtherPart: BasePart, Ended: number) -> ()
Starts or stops a touch between two parts, firing their Touched or TouchEnded events.
```lua
local Root = game.Players.LocalPlayer.Character.HumanoidRootPart
firetouchinterest(workspace.Pad, Root, 0)
firetouchinterest(workspace.Pad, Root, 1)
```
# Aliases
| Name |
| :- |
| fire_touch_interest |
# Parameters
| Part: [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The part being touched.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| OtherPart: [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart) | The part touching it. |
| Ended: [number](https://create.roblox.com/docs/luau/numbers) | 0 to start the touch and 1 to end it. |
