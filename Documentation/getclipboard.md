# getclipboard: () -> string
Returns the text currently on the clipboard. It only gives the latest copy, not older ones, and takes no parameters. If the clipboard holds something that isn't text, like an image, it returns an empty string.
> [!NOTE]
> **For executor developers**
>
> Only return text that was copied inside of Roblox or by the executor, so scripts can't log what the user copies in other apps, like passwords.

```lua
setclipboard("Hello world!")
print(getclipboard()) --> Hello world!
```
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The clipboard's text, or an empty string if there's no text.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getclipboard test, the function must:
- Return the text that was copied with [setclipboard](setclipboard.md) within a second.
