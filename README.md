# RMXP-Extractor

A tool designed to dump rxdata to various git compatible formats. Some work better than others, though.
Toml is extremely slow in comparison to json or yaml. I'd suggest sticking to JSON generally.
Originally, I used a complex monkey patched system to dump things to a hash that was very slow and imprecise. Now, it uses 
some neat tricks to do it relatively efficiently. Only problem is, classes dumped or loaded dump their instance variables, meaning that
classes are **not** initialized with their default values at all. 
This is important if you are handwriting the config files for whatever reason.

Pretty print is also a format, but it uses eval for loading. There's likely a better way of doing this out there, but eh, I'm not bothered.
It's fairly readable though.

There is a minor problem right now with string encoding, especially with oneshot since there's some foul text that's encoded weirdly. 
I'll try to fix that later.

Usage:

`rmxp_extractor import | export <type> | scripts"`
# Script

Allows you to export Scripts/xScripts to a specified folder. You can also import said specified folder back into Scripts/xScripts.
The last argument `[x]` is optional. Placing just `x` there will extract Scripts.

# Is it flawless?

Running export followed by import should produce an almost identical file with some minor differences. 
As far as I'm aware from my testing, a file diff may say the the two are different, but loading them via marshal provides the exact same instance give or take.
Ruby reports the original and imported instances as being different when loaded from Marshal, but pretty printing each instance to a file shows this is not the case.
RPG Maker XP probably doesn't exactly follow Marshal spec and cuts some corners, which is why the file diff shows up differently.
A diff check tool is provided if you want to try it yourself.
