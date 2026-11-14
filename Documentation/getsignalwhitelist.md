# getsignalwhitelist: () -> {{Parent: string, Event: string}}
Returns the signals that [replicatesignal](replicatesignal.md) can send.
```lua
for _, Entry in getsignalwhitelist() do
	print(Entry.Parent, Entry.Event)
end
```
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Parent: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Event: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;},<br>}</pre> | An array of the signals, with the class each one belongs to. |
# Test requirements
To pass the getsignalwhitelist test, the function must:
- Return a table.
- Include more than one signal.
- Give each entry as a table with `Event` and `Parent` strings that aren't empty.
- Include `Player.Kill`.
