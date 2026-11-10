# messagebox: (Text: string, Caption: string, Flags: number) -> number
Shows a Windows message box and returns the button that was clicked. Roblox keeps running while the box is open.
```lua
local Button = messagebox("Hello world!", "My script", 0)
print(Button) --> 1
```
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The message.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Caption: [string](https://create.roblox.com/docs/luau/strings) | The title of the box. |
| Flags: [number](https://create.roblox.com/docs/luau/numbers) | The Windows message box flags, like 0 for an OK button. |
# Returns
| [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The id of the button that was clicked.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the messagebox test, the function must:
- Keep Roblox running while the message box is open, instead of freezing it until the box is closed.
