# setclipboard: (Text: string) -> ()
Copies text to the clipboard.
```lua
setclipboard("Hello world!")
```
# Aliases
| Name |
| :- |
| set_clipboard |
| to_clipboard |
| toclipboard |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Text: [string](https://create.roblox.com/docs/luau/strings) | The text to copy. |

# Test requirements
To pass the setclipboard test, the function must:
- Copy the text it's given, so [getclipboard](getclipboard.md) returns it within 1 second.
