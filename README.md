# RMXP-Extractor

A tool for extracting rxdata to a more usable format, namely JSON. You could probably get it working with XML more easily.
I made this a while back, so I don't really remember how it works, other than it was pretty clunky and relied heavily on iteration.

Usage:

`rmxp_extractor import|export|sccripts`

# Import
Import will import all files in Data_JSON into the rxdata format. It'll take a bit.

# Export
Export will export all files in Data into json. It's a bit faster than JSON.

# Script

Allows you to export Scripts/xScripts to a specified folder. You can also import said specified folder back into Scripts/xScripts.
The last argument `[x]` is optional. Placing just `x` there will extract Scripts.

# Is it flawless

Running export followed by inport should produce an almost identical file with some minor differences. 
Move routes will display as blank since they have some extra serialization I don't understand yet, although they still work nontheless.
You may or may not find some files are also a few bytes longer, I'm unsure why. RPG Maker XP probably doesn't exactly follow Marshal spec and cuts some corners.
