# game.HttpGet: (Url: string, NoCache: boolean?) -> string
Sends a GET request and returns the body of the response. Requests to the same url are cached unless NoCache is true.
```lua
local Body = game:HttpGet("https://httpbin.org/get")
print(Body)
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Url: [string](https://create.roblox.com/docs/luau/strings) | The url to request. |
| NoCache: [boolean](https://create.roblox.com/docs/luau/booleans)? | Whether to skip a cached response from an earlier request to the same url. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The body of the response. |

# Test requirements
To pass the game.HttpGet test, the function must:
- Error, or return `nil` or an empty string, for a website that doesn't exist.
- Get a page without erroring.
- Return the page's real response, including the query that was sent.
- Return the JSON, HTML, or plain text response without erroring when `NoCache` is `true`.
- Return a fresh response every time `NoCache` is `true`.
- Skip the cache when `NoCache` is `true`, even when the same URL gave a cached response before.
- Cache responses when `NoCache` isn't set, so the same URL can return the same response twice.
