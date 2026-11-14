# request: (Options: {Url: string, Method: string?, Headers: {[string]: string}?, Body: string?}) -> {Success: boolean, StatusCode: number, StatusMessage: string, Headers: {[string]: string}, Body: string}
Sends an HTTP request.
```lua
local Response = request({
	Url = "https://httpbin.org/get",
	Method = "GET",
})

print(Response.StatusCode) --> 200
print(Response.Body)
```
# Aliases
| Library | Name |
| :- | :- |
| http | request |
| | http_request |
| | httprequest |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Options: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Url: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;Method: string?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Headers: {[string]: string}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Body: string?,<br>}</pre> | The Url, Method, Headers and Body of the request. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Success: boolean,<br>&nbsp;&nbsp;&nbsp;&nbsp;StatusCode: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;StatusMessage: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;Headers: {[string]: string},<br>&nbsp;&nbsp;&nbsp;&nbsp;Body: string,<br>}</pre> | The response. Each key is explained below. |
# Options
| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Url: [string](https://create.roblox.com/docs/luau/strings) | The url to request. |
| Method: [string?](https://create.roblox.com/docs/luau/strings) | The HTTP method, such as GET or POST. |
| Headers: [table?](https://create.roblox.com/docs/luau/tables) | The headers to send. |
| Body: [string?](https://create.roblox.com/docs/luau/strings) | The body to send. |
# Response
| Field&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Success: [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the request worked. This is false for a status like 404. |
| StatusCode: [number](https://create.roblox.com/docs/luau/numbers) | The status code, such as 200. |
| StatusMessage: [string](https://create.roblox.com/docs/luau/strings) | The status message, such as OK. |
| Headers: [table](https://create.roblox.com/docs/luau/tables) | The headers that came back. |
| Body: [string](https://create.roblox.com/docs/luau/strings) | The body that came back. |

# Test requirements
To pass the request test, the function must:
- Send a GET request with headers and a query without erroring.
- Return a table with a `StatusCode` of 200, a `StatusMessage` of `"OK"`, `Success` set to `true`, and a string `Body`.
- Send the headers and query it's given, so the server echoes them back.
- Send a fingerprint (HWID) header.
- Send POST, PUT, PATCH, and DELETE requests with the method and body they're given.
- Return a response with `Success` set to `false` and a `StatusCode` of 404 for a missing page, along with its `Headers` table.
- Return the full body for 1,024 random bytes.
- Follow redirects, returning a `StatusCode` of 200 after 2 redirects.
- Decode gzip responses.
- Keep the game running while it waits for a slow response.
