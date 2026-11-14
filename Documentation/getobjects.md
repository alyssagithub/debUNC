# getobjects: (Asset: string) -> {Instance}
Loads an asset and returns the Instances inside of it.
```lua
local Sword = getobjects("rbxassetid://125013769")[1]
print(Sword.Name) --> LinkedSword
```
# Aliases
| Name |
| :- |
| get_objects |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Asset: [string](https://create.roblox.com/docs/luau/strings) | The rbxassetid:// id of the asset. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)} | An array of Instances. |
# Test requirements
To pass the getobjects test, the function must:
- Return a table for `rbxassetid://125013769`.
- Return an instance as the first value.
- Load that asset as a Tool named `LinkedSword` with its `Handle`.
- Leave the loaded model unparented.
