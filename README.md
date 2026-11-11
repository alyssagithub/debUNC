# debUNC (debunk Unified Naming Convention)
like sUNC and UNC but better (made by vice (@wtits) on discord)

feel free to make an issue or PR whenever you have a suggestion, bug, or feedback you think would improve your use of this

all custom functions that debUNC tests are documented in [Documentation](Documentation)

reasons why i made this:
1. sUNC is obfuscated, sure u can ask the developers for the source code in order to debug but that's just an unnecessary step (it supposedly exists to stop devs trying to fake results, which is a poor excuse as you can just try the functions outside the sUNC test to realise they don't work)
2. sUNC's tests fail even though the function works (and vice versa), which atp, what is the test even for?
3. sUNC and UNC don't test ALL of the functions many scripts use, only the most necessary, which makes it so even with a 100% score it's not supporting every script's function use (e.g., volt and syn v3 docs have more functions)
4. sUNC and UNC don't display the executor's version in test results (only the date performed), making it easy for people to misinform with outdated results
5. sUNC and UNC aren't made by me (i want to be famous)
# Loadstring
```lua
loadstring(game:HttpGet("https://github.com/alyssagithub/debUNC/raw/main/debUNC.luau"))()
```
# Confirmed results (debUNC v2.12.0)
also you can use these results in https://github.com/alyssagithub/debUNC/raw/main/results.json for stuff like an api to see an executor's score

![Synapse Z](https://img.shields.io/badge/Synapse_Z_v1.0.4.0-75%25-yellow?style=for-the-badge)

![OpiumWare](https://img.shields.io/badge/OpiumWare_v2.6.0-71%25-yellow?style=for-the-badge)

![Athena](https://img.shields.io/badge/Athena_1.0-68%25-yellow?style=for-the-badge)

![Delta](https://img.shields.io/badge/Delta_1.0.745.1142-67%25-yellow?style=for-the-badge)

![Xeno](https://img.shields.io/badge/Xeno_v1.3.65-27%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| [Synapse Z](https://z.synapse.do) | v1.0.4.0 | **75%** | 76.97s | 166 | 26 | 2 | 25 |
| [OpiumWare](https://use.opiumware.today/) | v2.6.0 | **71%** | 25.06s | 156 | 24 | 13 | 26 |
| [Athena](https://getathena.gg/) | 1.0 | **68%** | 26.66s | 149 | 31 | 13 | 26 |
| [Delta](https://deltaexploits.gg/) (Android, MuMu) | 1.0.745.1142 | **67%** | 82.39s | 148 | 24 | 6 | 41 |
| [Xeno](https://www.xeno.now/) | v1.3.65 | **27%** | 34.84s | 61 | 55 | 10 | 93 |

<details>
<summary><b>Synapse Z details</b></summary>

**🔴 Failed**
- `DirectoryWatcher.new`: this crashes Roblox on Synapse Z, so it wasn't run, use shared.CrashTests = true to try it
- `Drawing.new`: expected a Text object's Font after setting it to 3 to be 3, got DrawFont: 0x09232b4d51669c00
- `Regex.new`: expected the whole match to be deeeb, got table: 0xf5756296c41d0b09
- `createcommchannel`: expected a number id, got string
- `crypt.encrypt`: invalid argument #2 to 'encrypt' (invalid key size)
- `crypt.hash`: the sha256 hash of 'abc' was wrong, got 89911f71a4508762a5791590153c68a9bbee326969d37b603697a692b3fdf553
- `decompile`: couldn't find '__index' in the decompiled 'CameraModule', it started with '-- Decompiled with Medal
- `dofile`: expected the value the file returned to be 0.5000893109654599, got File_0.8475375507776931.lua
- `game.HttpGet`: requesting the same url twice never gave a cached response, so NoCache has nothing to skip
- `game.HttpPost`: httpbin didn't answer with its JSON echo, so the request may not have gone out as a POST, got '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
- `getcommchannel`: expected a number id, got string
- `getcustomasset`: didn't finish within 60 seconds
- `gethiddenproperties`: expected size_xml to be 8, got nil
- `getproperties`: expected the Size in the returned table to be 5, 6, 7, got nil
- `getscripthash`: should be a 96 character sha384 hash, got 64 characters
- `getsenv`: getsenv returned nil when the parent was nil
- `gettenv`: missing argument #1 to 'gettenv' (thread expected)
- `hookfunction`: the hooked function took on the hook's environment, so getfenv can tell it was hooked
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `isparallel`: should return false in an actor before it desynchronizes
- `mousemoverel`: the mouse moved by -400, -299.5 then 0, 0, but moving by 25 then 50 should go the same way twice as far while Roblox wasn't focused, input should still reach Roblox
- `mousescroll`: missing argument #2 to 'mousescroll' (number expected) while Roblox wasn't focused, input should still reach Roblox
- `raknet.receive`: the receive hook didn't see the packet
- `security: account data and tokens stay private`: MarketplaceService:GetUserSubscriptionDetailsInternalAsync can be called, which lets scripts reach your private account data
- `security: scripts can't write programs`: scripts can write program files like debUNC.exe, debUNC.bat, debUNC.cmd, debUNC.com, debUNC.scr, debUNC.ps1, debUNC.vbs, debUNC.lnk, debUNC.msi, which could be run on your computer
- `trampolinecall`: expected the line of the fake caller to be 514, got 5734

**🟠 Skipped**
- `Regex.Escape`: couldn't be tested because Regex.new failed
- `crypt.decrypt`: couldn't be tested because crypt.encrypt failed

**🟡 Missing**
- `appendfileasync`
- `clearqueueonteleport`
- `comparefunctions`
- `crypt.hmac`
- `getactorfromthread`
- `getactorthreads`
- `getclipboard`
- `getfflagtype`
- `getfilesize`
- `getmenv`
- `getmetafield`
- `getmodules`
- `getoriginalenv`
- `getsignalwhitelist`
- `hasmetafield`
- `hasmetatable`
- `isexecutorthread`
- `isstackhidden`
- `loadfileasync`
- `movefile`
- `readfileasync`
- `renamefile`
- `saveinstance`
- `writecustomasset`
- `writefileasync`

</details>

<details>
<summary><b>OpiumWare details</b></summary>

</details>

<details>
<summary><b>Athena details</b></summary>

**🔴 Failed**
- `crypt.encrypt`: encrypting in CTR mode errored with only CBC mode is supported
- `game.HttpGet`: two JSON requests with NoCache set to true gave the same cached response, so true may be treated as cache instead of no cache
- `getactorthreads`: actor threads require a serial engine thread
- `getcallbackvalue`: should error for a property that isn't a callback
- `getfflagtype`: expected the type of a true or false flag to be bool, got DFFlag
- `getgc`: kept garbage alive while its result was held, so game scripts can detect it with a weak table (__mode is not set)
- `getrenv`: its 'print' isn't the real print
- `hookfunction`: the hooked function took on the hook's environment, so getfenv can tell it was hooked
- `hookmetamethod`: couldn't capture the game's __index and __namecall the way game scripts do
- `identifyexecutor`: the version '1.0' never changes between updates, it should be the real version of each release
- `isexecutorthread`: should error when given something that isn't a thread
- `keyclick`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `keypress`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `keyrelease`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `loadstring`: the compile error doesn't mention the chunk name, got ':1: Incomplete statement: expected assignment or a function call'
- `mouse1click`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mouse1press`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mouse1release`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mouse2click`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mouse2press`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mouse2release`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mousemoveabs`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mousemoverel`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `mousescroll`: input only works while Roblox is focused, athena sends it to whatever window is focused instead
- `raknet.addreceivehook`: the receive hook wasn't called within 3 seconds
- `raknet.addsendhook`: the send hook wasn't called within 3 seconds
- `runonthread`: the code didn't run on the thread
- `security: account data and tokens stay private`: MarketplaceService:GetUserSubscriptionPaymentHistoryAsync can be called, which lets scripts reach your private account data
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: requests can't use your login`: ContentProvider:SetBaseUrl, OpenCloudService:InvokeAsync can be called, which lets scripts send web requests logged in as you
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration, AvatarEditorService:SetAllowInventoryReadAccess can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `Regex.Escape`: couldn't be tested because Regex.new is missing
- `clonefunction`: couldn't be tested because debug.info is missing
- `debug.getproto`: couldn't be tested because debug.info is missing
- `debug.getprotos`: couldn't be tested because debug.info is missing
- `debug.isvalidlevel`: couldn't be tested because debug.info is missing
- `debug.setinfo`: couldn't be tested because debug.info is missing
- `getrawmetatable`: couldn't be tested because debug.info is missing
- `newcclosure`: couldn't be tested because debug.info is missing
- `raknet.receive`: skipped because the receive hook never fired, so the packet can't be checked
- `raknet.removereceivehook`: skipped because the receive hook never fired, so removing it can't be checked
- `raknet.removesendhook`: skipped because the send hook never fired, so removing it can't be checked
- `restorefunction`: couldn't be tested because hookfunction failed
- `setstackhidden`: couldn't be tested because debug.info is missing

**🟡 Missing**
- `Regex.new`
- `appendfileasync`
- `debug.info`
- `game.HttpPost`
- `getactorfromthread`
- `getclipboard`
- `getfilesize`
- `getfunctionreferences`
- `getmenv`
- `getmetafield`
- `getobjectreferences`
- `getoriginalenv`
- `hasmetafield`
- `hasmetatable`
- `iscorescript`
- `isstackhidden`
- `iswriteable`
- `loadfileasync`
- `makewriteable`
- `movefile`
- `readfileasync`
- `renamefile`
- `saveinstance`
- `trampolinecall`
- `writecustomasset`
- `writefileasync`

</details>

<details>
<summary><b>Delta (Android, MuMu Player) details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error on a type that doesn't exist
- `Regex.new`: Match returned a table without a Captures field
- `crypt.encrypt`: expected the published AES-256 CTR test vector to be YB7DE3dXiaW3p/UEu/PSKA==, got uM8XErAKO41dmHbOYZ0vuwc3LKRdmYS/XtnlKYqERMI=
- `dofile`: expected the value the file returned to be 0.3178547346792509, got nil
- `game.HttpGet`: requesting the same url twice never gave a cached response, so NoCache has nothing to skip
- `getallthreads`: didn't find the thread that's running this test
- `getcallbackvalue`: didn't return game.OnClose, a callback on the DataModel
- `getconnections`: the connection is still listed after :Disconnect()
- `getcustomasset`: didn't finish within 60 seconds
- `getmenv`: didn't return a table
- `getobjects`: expected an instance, got nil
- `getthreadidentity`: expected this thread's identity after another thread changed its own to be 8, got 3
- `hookfunction`: the hooked function took on the hook's environment, so getfenv can tell it was hooked
- `hookmetamethod`: the hook ran for bad calls that should have errored before reaching it (5 times)
- `isexecutorthread`: should error when given something that isn't a thread
- `mouse2press`: the input wasn't detected
- `mouse2release`: the input was never held down, so it can't be released
- `mousemoverel`: the mouse moved by 25, -33 then 50, -8, but moving by 25 then 50 should go the same way twice as far
- `mousescroll`: the scroll down wasn't detected
- `newcclosure`: catching an error thrown after a yield crashes Roblox on Delta, so it wasn't run, use shared.CrashTests = true to try it
- `runonactor`: the code didn't run on the actor
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking
- `setfpscap`: the frame rate averaged 59 over a second, which is above the cap of 15

**🟠 Skipped**
- `Regex.Escape`: couldn't be tested because Regex.new failed
- `crypt.decrypt`: couldn't be tested because crypt.encrypt failed
- `getactors`: couldn't be tested because runonactor failed
- `getfpscap`: couldn't be tested because setfpscap failed
- `isparallel`: couldn't be tested because runonactor failed
- `restorefunction`: couldn't be tested because hookfunction failed

**🟡 Missing**
- `DirectoryWatcher.new`
- `appendfileasync`
- `comparefunctions`
- `createcommchannel`
- `debug.setinfo`
- `getactorfromthread`
- `getactorthreads`
- `getclipboard`
- `getcommchannel`
- `getfflagtype`
- `getfilesize`
- `getfunctionreferences`
- `getmetafield`
- `getmodules`
- `getobjectreferences`
- `getoriginalenv`
- `gettenv`
- `hasmetafield`
- `hasmetatable`
- `hooksignal`
- `iscorescript`
- `issignalhooked`
- `isstackhidden`
- `iswriteable`
- `loadfileasync`
- `makewriteable`
- `movefile`
- `raknet.addreceivehook`
- `raknet.addsendhook`
- `raknet.receive`
- `raknet.removereceivehook`
- `raknet.removesendhook`
- `raknet.send`
- `readfileasync`
- `renamefile`
- `restoresignal`
- `runonthread`
- `saveinstance`
- `trampolinecall`
- `writecustomasset`
- `writefileasync`

</details>

<details>
<summary><b>Xeno details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error on a type that doesn't exist
- `checkcaller`: failed to require BaseCharacterController with the error Requested module experienced an error while loading
- `clonefunction`: "Line" isn't the same, it returned "2813" instead of "1329"
- `crypt.encrypt`: invalid argument #4 to 'encrypt' (string expected, got nil)
- `debug.getconstants`: didn't find the string constant
- `debug.getprotos`: expected the number of inner functions to be 2, got 0
- `debug.getstack`: couldn't find a local in the stack
- `debug.getupvalue`: didn't return the first upvalue
- `debug.setupvalue`: the upvalue wasn't changed
- `dofile`: expected the value the file returned to be 0.6142191423808852, got function: 0xea7c7249e2bbe37d
- `fireclickdetector`: the connection wasn't fired
- `fireproximityprompt`: didn't fire within a second for a prompt 10000 studs away with a 5 second HoldDuration
- `game.HttpGet`: requesting the same url twice never gave a cached response, so NoCache has nothing to skip
- `game.HttpPost`: didn't return a string
- `getcallingscript`: your executor needs to support 'require' to run this test
- `getconnections`: .Function isn't the function that was connected
- `getfflag`: Flag 'MaxFrameBufferSize' referenced from Lua as 'flag', but it was defined as 'int'
- `getgc`: didn't find a new function
- `getgenv`: missing 'script'
- `getinstances`: didn't find a new part
- `getloadedmodules`: StarterPlayerScripts.PlayerModule shouldn't be in the returned table
- `getnilinstances`: didn't find a part parented to nil
- `getrenv`: Not allowed to modify getrenv result
- `getscriptclosure`: the closure's script doesn't match
- `getscripthash`: should be a 96 character sha384 hash, got 64 characters
- `getsenv`: the script took too long to respond
- `getthreadidentity`: expected this thread's identity after another thread changed its own to be 2, got 3
- `hookfunction`: should return the original function, got nil
- `isscriptable`: should return false or error for game.a, which isn't a real property
- `keypress`: the input wasn't detected
- `keyrelease`: the input was never held down, so it can't be released
- `listfiles`: expected the number of things listed, since only the folder's direct children should be there, to be 2, got 3
- `loadstring`: the compile error doesn't mention the chunk name, got ':1: Incomplete statement: expected assignment or a function call'
- `mouse1click`: the input wasn't detected
- `mouse1press`: the input wasn't detected
- `mouse1release`: the input was never held down, so it can't be released
- `mouse2click`: the input wasn't detected
- `mouse2press`: the input wasn't detected
- `mouse2release`: the input was never held down, so it can't be released
- `mousemoveabs`: the mouse went to -1, -1 then -1, -1, which doesn't match moving to 344, 245.5 then 452, 333.5
- `mousemoverel`: the mouse moved by 0, 0 then 0, 0, but moving by 25 then 50 should go the same way twice as far
- `mousescroll`: the scroll up wasn't detected
- `newcclosure`: expected a wrapped function that yields to be 5, got nil
- `require`: expected success when requiring 'PlayerModule', got the error Requested module experienced an error while loading
- `saveinstance`: didn't return a string
- `security`: file:// is blocked: game:HttpPost can read files on your computer through file://
- `security: files outside the workspace stay hidden`: isfile can see 'C:/Windows/win.ini' outside of the workspace
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: requests can't use your login`: OpenCloudService:InvokeAsync can be called, which lets scripts send web requests logged in as you
- `security: scripts can't write programs`: scripts can write program files like ./debUNC.cmd, ./debUNC.EXE, ./debUNC.msi, ./debUNC.exe, ./debUNC.lnk, ./debUNC.ps1, ./debUNC.scr, ./debUNC.com, ./debUNC.txt.exe, ./debUNC.bat, ./debUNC.vbs, which could be run on your computer
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking
- `sethiddenproperty`: expected size_xml to be 6, got 5
- `setreadonly`: failed to write after unfreezing, got CoreGui.5480.Loadstring.loadstring:737820:3230: attempt to modify a readonly table
- `setscriptable`: size_xml couldn't be read after it was made scriptable
- `setthreadidentity`: CoreGui could still be read at identity 2

**🟠 Skipped**
- `cleardrawcache`: couldn't be tested because Drawing.new failed
- `crypt.decrypt`: couldn't be tested because crypt.encrypt failed
- `crypt.generatebytes`: couldn't be tested because base64decode is missing
- `crypt.generatekey`: couldn't be tested because base64decode is missing
- `debug.getconstant`: couldn't be tested because debug.getconstants failed
- `debug.setconstant`: couldn't be tested because debug.getconstants failed
- `debug.setstack`: couldn't be tested because debug.getstack failed
- `decompile`: couldn't be tested because debug.getconstants failed
- `security: game scripts don't get executor powers`: skipped because setthreadidentity didn't really lower the identity, so what game scripts can do couldn't be checked
- `setfflag`: couldn't be tested because getfflag failed

**🟡 Missing**
- `DirectoryWatcher.new`
- `Regex.Escape`
- `Regex.new`
- `Signal.new`
- `appendfileasync`
- `base64decode`
- `base64encode`
- `cansignalreplicate`
- `clearqueueonteleport`
- `comparefunctions`
- `createcommchannel`
- `crypt.hmac`
- `crypt.random`
- `debug.getcallstack`
- `debug.getregistry`
- `debug.getupvalues`
- `debug.isvalidlevel`
- `debug.setinfo`
- `filtergc`
- `firesignal`
- `getactorfromthread`
- `getactors`
- `getactorthreads`
- `getallthreads`
- `getcallbackvalue`
- `getclipboard`
- `getcommchannel`
- `getfflagtype`
- `getfilesize`
- `getfunctionbytecode`
- `getfunctionhash`
- `getfunctionreferences`
- `getmenv`
- `getmetafield`
- `getmodules`
- `getnamecallmethod`
- `getobjectreferences`
- `getobjects`
- `getoriginalenv`
- `getrawmetatable`
- `getrendersteppedlist`
- `getscriptfromthread`
- `getscriptthread`
- `getsignalarguments`
- `getsignalargumentsinfo`
- `getsignalwhitelist`
- `gettenv`
- `hasmetafield`
- `hasmetatable`
- `hookmetamethod`
- `hookproto`
- `hooksignal`
- `iscorescript`
- `isexecutorthread`
- `isfunctionhooked`
- `isnewcclosure`
- `isparallel`
- `isprotohooked`
- `issignalhooked`
- `isstackhidden`
- `iswriteable`
- `keyclick`
- `loadfileasync`
- `makereadonly`
- `makewriteable`
- `messagebox`
- `movefile`
- `oth.get_original_thread`
- `oth.get_root_callback`
- `oth.hook`
- `oth.is_hook_thread`
- `oth.unhook`
- `raknet.addreceivehook`
- `raknet.addsendhook`
- `raknet.receive`
- `raknet.removereceivehook`
- `raknet.removesendhook`
- `raknet.send`
- `rconsoleerr`
- `readfileasync`
- `renamefile`
- `replicatesignal`
- `restorefunction`
- `restoreproto`
- `restoresignal`
- `runonactor`
- `runonthread`
- `setnamecallmethod`
- `setrawmetatable`
- `setstackhidden`
- `trampolinecall`
- `writecustomasset`
- `writefileasync`

</details>

# Confirmed results (debUNC v2.11.0)
![Madium](https://img.shields.io/badge/Madium_2.0.0-100%25-brightgreen?style=for-the-badge)

![Kawaii](https://img.shields.io/badge/Kawaii_1.8.0-98%25-brightgreen?style=for-the-badge)

![Yuari](https://img.shields.io/badge/Yuari_1.1.0-96%25-brightgreen?style=for-the-badge)

![Lucid](https://img.shields.io/badge/Lucid_1.0.0-90%25-brightgreen?style=for-the-badge)

![Bunni](https://img.shields.io/badge/Bunni_2.0-69%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| [Madium](https://getmadium.net/) | 2.0.0 | **100%** | 18.12s | 218 | 0 | 0 | 0 |
| [Kawaii](https://lua.paramore.su/) (Android, MuMu) | 1.8.0 | **98%** | 25.18s | 215 | 3 | 0 | 0 |
| [Yuari](https://yuari.xyz/) | 1.1.0 | **96%** | 20.93s | 211 | 2 | 3 | 2 |
| [Lucid](https://getlucid.gg/) | 1.0.0 | **90%** | 19.94s | 198 | 6 | 7 | 7 |
| [Bunni](https://bunni.fun/) | 2.0 | **69%** | 11.37s | 152 | 37 | 1 | 28 |

<details>
<summary><b>Kawaii (Android, MuMu Player) details</b></summary>

**🔴 Failed**
- `getcallbackvalue`: should error for a property that isn't a callback
- `hookmetamethod`: the hook ran for bad calls that should have errored before reaching it (1 times)
- `security: game scripts don't get executor powers`: loadstring works at the game's own identity, which lets game scripts use executor powers

**🟠 Skipped**

**🟡 Missing**

</details>

<details>
<summary><b>Yuari details</b></summary>

**🔴 Failed**
- `raknet.addreceivehook`: the receive hook wasn't called within 3 seconds
- `raknet.addsendhook`: the send hook wasn't called within 3 seconds

**🟠 Skipped**
- `isprotohooked`: couldn't be tested because hookproto is missing

**🟡 Missing**
- `hookproto`

</details>

<details>
<summary><b>Lucid details</b></summary>

**🔴 Failed**
- `Regex.new`: expected Replace on text with two matches to be Z Z, got Z deeb
- `hookfunction`: expected a function hooked twice, where the second hook's original should call the first hook, to be 40, got 30
- `hookmetamethod`: the __namecall hook could be found on the stack from an error handler, so game scripts can detect it
- `identifyexecutor`: the version '1.0.0' never changes between updates, it should be the real version of each release
- `rconsolecreate`: rconsolehidden returned true after rconsoleshow, so the console didn't open
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `rconsoleclear`: couldn't be tested because rconsolecreate failed
- `rconsoledestroy`: couldn't be tested because rconsolecreate failed
- `rconsoleerr`: couldn't be tested because rconsolecreate failed
- `rconsoleinfo`: couldn't be tested because rconsolecreate failed
- `rconsoleprint`: couldn't be tested because rconsolecreate failed
- `rconsolesettitle`: couldn't be tested because rconsolecreate failed
- `rconsolewarn`: couldn't be tested because rconsolecreate failed

**🟡 Missing**
- `DirectoryWatcher.new`
- `getclipboard`
- `getfilesize`
- `isexecutorthread`
- `isstackhidden`
- `movefile`
- `renamefile`

</details>

<details>
<summary><b>Bunni details</b></summary>

**🔴 Failed**
- `Regex.new`: Match should return a table with Captures, got string
- `cansignalreplicate`: should return true for Player.Kill
- `crypt.encrypt`: encrypting in CTR mode errored with invalid argument #4 to 'encrypt' (only CBC mode is supported)
- `dofile`: expected the value the file returned to be 0.6636033218273789, got nil
- `game.HttpGet`: game:HttpGet on a website that doesn't exist should return an error, nil, or an empty string
- `getactorthreads`: expected at least one actor thread
- `getcallbackvalue`: should error for a property that isn't a callback
- `getfpscap`: expected the fps cap to be 10, got 0
- `getmodules`: didn't find a new ModuleScript
- `getsignalarguments`: expected the number of arguments Touched has to be 1, got 124
- `getsignalargumentsinfo`: expected the name of Touched's argument to be otherPart, got Instance
- `hookfunction`: expected a function hooked twice, where the second hook's original should call the first hook, to be 40, got 30
- `hookmetamethod`: calling the game's __index with a string as self gave "invalid argument #1 to 'hookfunction' (Instance expected, got string)" once it was hooked instead of "invalid argument #1 (Instance expected, got string)", so game scripts can detect the hook
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `identifyexecutor`: the version '2.0' never changes between updates, it should be the real version of each release
- `isparallel`: should return false in an actor before it desynchronizes
- `keyclick`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `keypress`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `keyrelease`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `messagebox`: Roblox froze while the message box was open, only 107 frames ran in 4.2 seconds
- `mouse1click`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mouse1press`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mouse1release`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mouse2click`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mouse2press`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mouse2release`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mousemoveabs`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mousemoverel`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `mousescroll`: input only works while Roblox is focused, Bunni sends it to whatever window is focused instead
- `raknet.send`: invalid argument #1 to 'send' (string expected, got buffer)
- `replicatesignal`: should error on a signal that can't be replicated
- `request`: a gzip response wasn't decoded, got status nil and body 'nil'
- `saveinstance`: didn't return a string
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: scripts can't write programs`: scripts can write program files like debUNC.exe, which could be run on your computer
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking
- `trampolinecall`: the first value it returns should be whether the call worked, got string instead, so it probably just called the function

**🟠 Skipped**
- `restoresignal`: couldn't be tested because hooksignal failed

**🟡 Missing**
- `DirectoryWatcher.new`
- `appendfileasync`
- `createcommchannel`
- `debug.getcallstack`
- `debug.isvalidlevel`
- `debug.setinfo`
- `getactorfromthread`
- `getcommchannel`
- `getfunctionbytecode`
- `getfunctionreferences`
- `gethwid`
- `getobjectreferences`
- `gettenv`
- `hookproto`
- `iscorescript`
- `isprotohooked`
- `issignalhooked`
- `loadfileasync`
- `raknet.addreceivehook`
- `raknet.addsendhook`
- `raknet.receive`
- `raknet.removereceivehook`
- `raknet.removesendhook`
- `readfileasync`
- `restoreproto`
- `runonthread`
- `writecustomasset`
- `writefileasync`

</details>

# Confirmed results (debUNC v2.10.0)
![Real](https://img.shields.io/badge/Real_3.1.0-81%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| [Real](https://realest.gg) | 3.1.0 | **81%** | 21.9s | 175 | 10 | 1 | 30 |

<details>
<summary><b>Real details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error when Thickness is set to a string
- `dofile`: expected the value the file returned to be 0.5164174934738532, got function: 0x9635d78569c54a84
- `getactorfromthread`: didn't return the actor that the thread is running on
- `getmenv`: invalid thread
- `getscripthash`: the hash isn't the sha384 of the script's bytecode
- `mousemoveabs`: the mouse went to 429, 346 instead of 356.947357, 313.947357
- `mousescroll`: the scroll up wasn't detected
- `raknet.addreceivehook`: the receive hook wasn't called within 3 seconds
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `raknet.removereceivehook`: skipped because the receive hook never fired, so removing it can't be checked

**🟡 Missing**
- `DirectoryWatcher.new`
- `Regex.Escape`
- `Regex.new`
- `debug.getcallstack`
- `debug.setinfo`
- `getclipboard`
- `getfilesize`
- `getfunctionbytecode`
- `getfunctionreferences`
- `getmodules`
- `getobjectreferences`
- `getobjects`
- `hookproto`
- `hooksignal`
- `iscorescript`
- `isexecutorthread`
- `isprotohooked`
- `issignalhooked`
- `iswriteable`
- `movefile`
- `oth.get_original_thread`
- `oth.get_root_callback`
- `oth.hook`
- `oth.is_hook_thread`
- `oth.unhook`
- `raknet.receive`
- `renamefile`
- `restoreproto`
- `restoresignal`
- `trampolinecall`

</details>
