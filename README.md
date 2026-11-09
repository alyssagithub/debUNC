# debUNC (debunk Unified Naming Convention)
like sUNC and UNC but better (made by vice (@wtits) on discord)

feel free to make an issue or PR whenever you have a suggestion, bug, or feedback you think would improve your use of this

all custom functions that debUNC tests are documented in [Documentation](Documentation)

reasons why i made this:
1. sUNC is obfuscated, sure u can ask the developers for the source code in order to debug but that's just an unnecessary step
2. sUNC's tests fail even though the function works, which atp what is the test even for?
3. sUNC and UNC don't test ALL of the functions many scripts use, only the most necessary, which makes it so even with a 100% score it's not supporting every script's function use
4. sUNC and UNC don't display the executor's version in test results, making it easy for people to misinform with outdated results
5. sUNC and UNC aren't made by me (i want to be famous)
# Loadstring
```lua
loadstring(game:HttpGet("https://github.com/alyssagithub/debUNC/raw/main/debUNC.luau"))()
```
# Confirmed results (debUNC v2.10.0)
![Kawaii](https://img.shields.io/badge/Kawaii_unreleased-100%25-brightgreen?style=for-the-badge)

![Lucid](https://img.shields.io/badge/Lucid_1.0.0-92%25-brightgreen?style=for-the-badge)

![Real](https://img.shields.io/badge/Real_3.1.0-81%25-yellow?style=for-the-badge)

![Synapse Z](https://img.shields.io/badge/Synapse_Z_v1.0.4.0-76%25-yellow?style=for-the-badge)

![Athena](https://img.shields.io/badge/Athena_1.0-76%25-yellow?style=for-the-badge)

![Bunni](https://img.shields.io/badge/Bunni_2.0-74%25-yellow?style=for-the-badge)

![Delta](https://img.shields.io/badge/Delta_1.0.745.1142-70%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Kawaii (Android, MuMu) | unreleased | **100%** | 23.31s | 206 | 0 | 0 | 0 |
| Lucid | 1.0.0 | **92%** | 18.24s | 197 | 5 | 5 | 7 |
| Real | 3.1.0 | **81%** | 19.47s | 175 | 9 | 1 | 29 |
| Synapse Z | v1.0.4.0 | **76%** | 21.51s | 163 | 25 | 2 | 24 |
| Athena | 1.0 | **76%** | 21.11s | 164 | 15 | 10 | 25 |
| Bunni | 2.0 | **74%** | 19.06s | 159 | 26 | 1 | 28 |
| Delta (Android, MuMu) | 1.0.745.1142 | **68%** | 80.2s | 147 | 22 | 5 | 40 |

<details>
<summary><b>Lucid details</b></summary>

**🔴 Failed**
- `Regex.new`: expected Replace on text with two matches to be Z Z, got Z deeb
- `hookfunction`: expected a function hooked twice, where the second hook's original should call the first hook, to be 40, got 30
- `identifyexecutor`: the version '1.0.0' never changes between updates, it should be the real version of each release
- `rconsolecreate`: rconsolehidden returned true after rconsoleshow, so the console didn't open
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `rconsoledestroy`: couldn't be tested because rconsolecreate failed
- `rconsoleerr`: couldn't be tested because rconsolecreate failed
- `rconsoleinfo`: couldn't be tested because rconsolecreate failed
- `rconsoleprint`: couldn't be tested because rconsolecreate failed
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
<summary><b>Real details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error when Thickness is set to a string
- `dofile`: expected the value the file returned to be 0.4572065749163503, got function: 0x66017a2da832cd97
- `getactorfromthread`: didn't return the actor that the thread is running on
- `getmenv`: invalid thread
- `getscripthash`: the hash isn't the sha384 of the script's bytecode
- `mousemoveabs`: the mouse went to 344, 255 then 344, 255, which doesn't match moving to 354, 259.5 then 451, 354.5
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

<details>
<summary><b>Synapse Z details</b></summary>

**🔴 Failed**
- `DirectoryWatcher.new`: this crashes Roblox on Synapse Z, so it wasn't run, use shared.CrashTests = true to try it
- `Drawing.new`: expected a Text object's Font after setting it to 3 to be 3, got DrawFont: 0x1460bdea73d9c45f
- `Regex.new`: expected the whole match to be deeeb, got table: 0x1ce3e271d66a4fbc
- `createcommchannel`: expected a number id, got string
- `crypt.encrypt`: invalid argument #2 to 'encrypt' (invalid key size)
- `crypt.hash`: the sha256 hash of 'abc' was wrong, got 89911f71a4508762a5791590153c68a9bbee326969d37b603697a692b3fdf553
- `decompile`: couldn't find '__index' in the decompiled 'CameraModule', it started with '-- Decompiled with Medal
- `dofile`: expected the value the file returned to be 0.9603614832691958, got File_0.9488137120687681.lua
- `game.HttpGet`: requesting the same url twice never gave a cached response, so NoCache has nothing to skip
- `game.HttpPost`: httpbin didn't answer with its JSON echo, so the request may not have gone out as a POST, got '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
- `getcommchannel`: expected a number id, got string
- `gethiddenproperties`: expected size_xml to be 9, got nil
- `getproperties`: expected the Size in the returned table to be 1, 5, 9, got nil
- `getscripthash`: should be a 96 character sha384 hash, got 64 characters
- `getsenv`: getsenv returned nil when the parent was nil
- `gettenv`: missing argument #1 to 'gettenv' (thread expected)
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `isparallel`: should return false in an actor before it desynchronizes
- `mousemoveabs`: the mouse went to 400, 299 then 360, 248, which doesn't match moving to 360, 248.5 then 430, 346.5
- `mousemoverel`: the mouse moved by -30, -47 then 21, 21, but moving by 25 then 50 should go the same way twice as far
- `mousescroll`: missing argument #2 to 'mousescroll' (number expected)
- `raknet.receive`: the receive hook didn't see the packet
- `security: account data and tokens stay private`: MarketplaceService:GetUserSubscriptionDetailsInternalAsync can be called, which lets scripts reach your private account data
- `security: scripts can't write programs`: scripts can write program files like debUNC.exe, debUNC.bat, debUNC.cmd, debUNC.com, debUNC.scr, debUNC.ps1, debUNC.vbs, debUNC.lnk, debUNC.msi, which could be run on your computer
- `trampolinecall`: expected the line of the fake caller to be 138, got 5039

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
<summary><b>Athena details</b></summary>

**🔴 Failed**
- `crypt.encrypt`: encrypting in CTR mode errored with only CBC mode is supported
- `game.HttpGet`: two JSON requests with NoCache set to true gave the same cached response, so true may be treated as cache instead of no cache
- `getfflagtype`: expected the type of a true or false flag to be bool, got DFFlag
- `getrenv`: its 'print' isn't the real print
- `hookfunction`: expected a function hooked twice, where the second hook's original should call the first hook, to be 40, got 30
- `identifyexecutor`: the version '1.0' never changes between updates, it should be the real version of each release
- `isexecutorthread`: should error when given something that isn't a thread
- `isrbxactive`: still returned true after the Roblox window lost focus
- `loadstring`: the compile error doesn't mention the chunk name, got ':1: Incomplete statement: expected assignment or a function call'
- `mousemoverel`: the mouse moved by 21, 21 then 0, 0, but moving by 25 then 50 should go the same way twice as far
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
<summary><b>Bunni details</b></summary>

**🔴 Failed**
- `Regex.new`: Match should return a table with Captures, got string
- `cansignalreplicate`: should return true for Player.Kill
- `crypt.encrypt`: encrypting in CTR mode errored with invalid argument #4 to 'encrypt' (only CBC mode is supported)
- `dofile`: expected the value the file returned to be 0.6464661251771143, got nil
- `game.HttpGet`: game:HttpGet on a website that doesn't exist should return an error, nil, or an empty string
- `getactorthreads`: expected at least one actor thread
- `getfpscap`: expected the fps cap to be 10, got 0
- `getmodules`: didn't find a new ModuleScript
- `getsignalarguments`: expected the number of arguments Touched has to be 1, got 124
- `getsignalargumentsinfo`: expected the name of Touched's argument to be otherPart, got Instance
- `hookfunction`: expected a function hooked twice, where the second hook's original should call the first hook, to be 40, got 30
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `identifyexecutor`: the version '2.0' never changes between updates, it should be the real version of each release
- `isparallel`: should return false in an actor before it desynchronizes
- `keyclick`: the key press wasn't detected
- `keypress`: the input wasn't detected
- `keyrelease`: the input was never held down, so it can't be released
- `mousemoveabs`: the mouse went to 386, 320 instead of 330, 301
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

<details>
<summary><b>Delta (Android, MuMu Player) details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error on a type that doesn't exist
- `Regex.new`: Match returned a table without a Captures field
- `crypt.encrypt`: expected the published AES-256 CTR test vector to be YB7DE3dXiaW3p/UEu/PSKA==, got uM8XErAKO41dmHbOYZ0vuwc3LKRdmYS/XtnlKYqERMI=
- `dofile`: expected the value the file returned to be 0.6981886443241281, got nil
- `game.HttpGet`: requesting the same url twice never gave a cached response, so NoCache has nothing to skip
- `getallthreads`: didn't find the thread that's running this test
- `getconnections`: the connection is still listed after :Disconnect()
- `getcustomasset`: didn't finish within 60 seconds
- `getmenv`: didn't return a table
- `getobjects`: expected an instance, got nil
- `getthreadidentity`: expected this thread's identity after another thread changed its own to be 8, got 3
- `isexecutorthread`: should error when given something that isn't a thread
- `mouse2press`: the input wasn't detected
- `mouse2release`: the input was never held down, so it can't be released
- `mousemoverel`: the mouse moved by 25, -33 then 50, -8, but moving by 25 then 50 should go the same way twice as far
- `mousescroll`: the scroll down wasn't detected
- `newcclosure`: catching an error thrown after a yield crashes Roblox on Delta, so it wasn't run, use shared.CrashTests = true to try it
- `restorefunction`: expected math.frexp's error after hooking and restoring it to be invalid argument #1 to 'frexp' (number expected, got string), got invalid argument #1 to 'sign' (number expected, got string)
- `runonactor`: the code didn't run on the actor
- `security: purchases need your approval`: MarketplaceService:PromptNativePurchaseWithContext, MarketplaceService:PromptNativePurchaseWithLocalPlayerWithPaymentSessionId, MarketplaceService:PromptNativePurchaseWithPaymentSessionId can be called, which lets scripts spend your Robux without asking
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking
- `setfpscap`: the frame rate averaged 60 over a second, which is above the cap of 14

**🟠 Skipped**
- `Regex.Escape`: couldn't be tested because Regex.new failed
- `crypt.decrypt`: couldn't be tested because crypt.encrypt failed
- `getactors`: couldn't be tested because runonactor failed
- `getfpscap`: couldn't be tested because setfpscap failed
- `isparallel`: couldn't be tested because runonactor failed

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
