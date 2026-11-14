# Drawing.new: (Type: string) -> DrawingObject
Creates a Drawing object that renders on top of the game.
```lua
local Line = Drawing.new("Line")
Line.From = Vector2.new(0, 0)
Line.To = Vector2.new(100, 100)
Line.Visible = true
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Type: [string](https://create.roblox.com/docs/luau/strings) | The type of object, such as Line, Text or Square. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| DrawingObject | The Drawing object, with the properties and methods below. |
# All Objects
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Visible: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it renders. |
| ZIndex: [number](https://create.roblox.com/docs/luau/numbers) | Which objects it renders above. |
| Transparency: [number](https://create.roblox.com/docs/luau/numbers) | How solid it is, where 1 is fully solid and lower values fade it out. This is the opposite of Roblox's Transparency. |
| Color: [Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3) | Its color. |
| __OBJECT_EXISTS: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the object still exists. |
# Line
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| From: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Where the line starts. |
| To: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Where the line ends. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the line is. |
# Text
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Text: [string](https://create.roblox.com/docs/luau/strings) | The text to show. |
| Size: [number](https://create.roblox.com/docs/luau/numbers) | The size of the text. |
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | Where the text is. |
| Font: [number](https://create.roblox.com/docs/luau/numbers) | The font from [Drawing.Fonts](Fonts.md). |
| Center: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the text is centered. |
| Outline: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the text has an outline. |
| OutlineColor: [Color3](https://create.roblox.com/docs/reference/engine/datatypes/Color3) | The color of the outline. |
| TextBounds: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | How much space the text takes up. |
# Circle
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The center of the circle. |
| Radius: [number](https://create.roblox.com/docs/luau/numbers) | The radius of the circle. |
| NumSides: [number](https://create.roblox.com/docs/luau/numbers) | How many sides are used to draw it. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Square
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Position: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The top left corner. |
| Size: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The size of the square. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Triangle
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| PointA: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The first corner. |
| PointB: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The second corner. |
| PointC: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The third corner. |
| Thickness: [number](https://create.roblox.com/docs/luau/numbers) | How thick the outline is. |
| Filled: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's filled in. |
# Quad
| Property&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| PointA: [Vector2](https://create.roblox.com/docs/reference/engine/datatypes/Vector2) | The first corner. |
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
# Test requirements
To pass the Drawing.new test, the function must:
- Error when it's given a type that doesn't exist.
- Error when `Thickness` is set to a string.
- Keep a Text object's `Font` at 3 after it's set to 3.
- Create Line, Text, Image, Circle, Square, Quad, and Triangle objects with `Visible` set to false.
- Keep decimal values, so `Thickness` stays 2.5 and `Transparency` stays 0.25 after they're set.
- Give `Thickness` as a number and `Visible` as a boolean.
- Set `__OBJECT_EXISTS` to true while the object exists and to false after `:Remove()` is called.
