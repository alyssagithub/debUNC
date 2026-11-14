# getclipboard: () -> string
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The clipboard's text, or an empty string if there's no text. |

# Test requirements
To pass the getclipboard test, the function must:
- Return the text that was copied with [setclipboard](setclipboard.md) within a second.
