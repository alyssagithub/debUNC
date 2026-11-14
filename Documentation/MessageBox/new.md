# MessageBox.new: (Options: {[string]: any}) -> MessageBox
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Creates a message box that can show custom text, buttons and icons, and tells you which button was pressed.
```lua
local Box = MessageBox.new({
	Title = "debUNC",
	Text = "Do you want to reset your character?",
	Icon = MessageBox.Icons.Question,
	Buttons = {"Reset", "Cancel"},
	Duration = 15,

	Callback = function(Choice)
		print(`picked {Choice}`)

		if Choice ~= "Reset" then
			return
		end

		game:GetService("Players").LocalPlayer.Character:BreakJoints()
	end,
})

Box:Show()
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Options: {[string]: any} | The options below, all of them optional. |
# Options
| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Option | What it does |
| Title: string | The text in the title bar. |
| Text: string | The text in the body. |
| Icon: string | A preset from `MessageBox.Icons` (`Error`, `Question`, `Warning` or `Information`, the same icons as Windows' `MessageBoxW`), or the path of an image in the workspace folder. |
| Buttons: {string} | A list of button texts. Defaults to a single `"Ok"` button. |
| Duration: number | How many seconds it stays open before it closes by itself. It stays open if this isn't given. |
| Yield: boolean | Whether `:Show()` yields until a choice is made. Defaults to `true`. |
| Callback: (Choice: string) -> () | The function that runs once with the choice. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| MessageBox | The message box, with the methods below. |
# Choices
| Choice&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | When it's given&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| The button's text | A button was pressed. |
| `"Closed"` | The box was exited out of. |
| `"ForceClosed"` | The box was closed with `:Close()`. |
| `"TimedOut"` | `Duration` ran out. |
| `"InternalError"` | The executor couldn't show the box. |
# Methods
## Show: () -> ()
Shows the message box. It yields until a choice is made when `Yield` is `true`.
```lua
Box:Show()
```
## Close: () -> ()
Closes the message box, which gives the callback `"ForceClosed"`.
```lua
Box:Close()
```
## OnChoice: (Callback: (Choice: string) -> ()) -> ()
Sets the callback, replacing the one given in the options.
```lua
Box:OnChoice(function(Choice)
	print(Choice)
end)
```
# Test requirements
To pass the MessageBox.new test, the function must:
- Have the `Error`, `Question`, `Warning` and `Information` presets in `MessageBox.Icons`.
- Give the callback `"TimedOut"` once `Duration` runs out.
- Make `:Show()` yield until a choice is made when `Yield` is `true`.
- Make `:Show()` return right away when `Yield` is `false`.
- Give the function set with `:OnChoice()` `"ForceClosed"` when `:Close()` is called.
