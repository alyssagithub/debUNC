# game.HttpPost: (Url: string, Data: string, ContentType: string?) -> string
Sends a POST request and returns the body of the response.
```lua
local Body = game:HttpPost("https://httpbin.org/post", "hello", "text/plain")
print(Body)
```
# Parameters
| Url: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The url to send to.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The body to send. |
| ContentType: [string](https://create.roblox.com/docs/luau/strings)? | The Content-Type header to send with it. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The body of the response.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the game.HttpPost test, the function must:
- Post without erroring.
- Return a string.
- Send the request as a POST, so the server answers with its JSON echo.
- Send the body it's given.
- Send the content type it's given.
