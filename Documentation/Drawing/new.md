# Drawing.new: (Type: string) -> DrawingObject
Creates a Drawing object that renders on top of the game.
```lua
local Line = Drawing.new("Line")
Line.From = Vector2.new(0, 0)
Line.To = Vector2.new(100, 100)
Line.Visible = true
```
# Parameters
| Type: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The type of object, such as Line, Text or Square.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| DrawingObject&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Drawing object, with the properties and methods below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# All Objects
| Visible: [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it renders.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ZIndex: [number](https://create.roblox.com/docs/luau/numbers) | Which objects it renders above. |
| Transparency: [number](https://create.roblox.com/docs/luau/numbers) | How solid it is, where 1 is fully solid and lower values fade it out. This is the opposite of Roblox's Transparency. |
| Color: [Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3) | Its color. |
| __OBJECT_EXISTS: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the object still exists. |
# Line
| From: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Where the line starts.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| To: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Where the line ends. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the line is. |
# Text
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The text to show.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Size: [number](https://create.roblox.com/docs/luau/numbers) | The size of the text. |
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Where the text is. |
| Font: [number](https://create.roblox.com/docs/luau/numbers) | The font from [Drawing.Fonts](Fonts.md). |
| Center: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the text is centered. |
| Outline: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the text has an outline. |
| OutlineColor: [Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3) | The color of the outline. |
| TextBounds: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | How much space the text takes up. |
# Circle
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The center of the circle.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Radius: [number](https://create.roblox.com/docs/luau/numbers) | The radius of the circle. |
| NumSides: [number](https://create.roblox.com/docs/luau/numbers) | How many sides are used to draw it. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Square
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The top left corner.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Size: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The size of the square. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Triangle
| PointA: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The first corner.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| PointB: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The second corner. |
| PointC: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The third corner. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Quad
| PointA: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The first corner.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| PointB: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The second corner. |
| PointC: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The third corner. |
| PointD: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The fourth corner. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Methods
## Remove: () -> ()
Deletes the object, and sets __OBJECT_EXISTS to false.
```lua
Line:Remove()
```
## Destroy: () -> ()
The same as Remove.
```lua
Line:Destroy()
```
