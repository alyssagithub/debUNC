# DirectoryWatcher.new: (Path: string) -> DirectoryWatcher
Watches a folder in the workspace folder and fires a signal when a file in it changes, even when it was changed outside of Roblox. It's much cheaper than checking the files over and over with `listfiles` and `readfile`.
```lua
makefolder("Scripts")

local Watcher = DirectoryWatcher.new("Scripts")

Watcher.OnChanged:Connect(function(Path)
	print(Path) --> Scripts/Main.lua
end)

writefile("Scripts/Main.lua", "print('Hello world!')")
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the folder to watch.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| DirectoryWatcher&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The watcher, with the properties and methods below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Properties
| OnChanged: Signal&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A signal that fires with the path of each file that changes.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Methods
## Destroy: () -> ()
Stops watching the folder, so `OnChanged` won't fire anymore.
```lua
Watcher:Destroy()
```
# Test requirements
To pass the DirectoryWatcher.new test, the function must:
- Fire `OnChanged` after a file inside the watched folder is written.
- Pass the changed file's path to `OnChanged`.
- Ignore changes to files in other folders.
- Stop firing `OnChanged` after the watcher is destroyed with `:Destroy()`.
