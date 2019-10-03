---
layout: note
title: Houdini
date: 2019-10-02 18:54:52 -0700
---

Notes on SideFX Houdini, HoudiniEngine, and HoudiniEngine for Unreal Engine 4.

- [Documentation](https://www.sidefx.com/docs/)
- [VEX language reference](https://www.sidefx.com/docs/houdini/vex/lang)
- [Doug's Houdini Examples](https://github.com/drichardson/HoudiniExamples)

# Game Development Toolset
A collection of Houdini tools developed by SideFX for game development.

- [Overview](https://www.sidefx.com/tutorials/game-development-toolset-overview/)
- [Source Code](https://github.com/sideeffects/GameDevelopmentToolset)
- [Houdini Tools with SideFX](https://www.youtube.com/watch?v=gL_-JY7wryI&t=271s)

# Houdini Engine for Unreal
Unreal Engine 4 plugin for Houdini. Let's you create
Houdini Digital Assets in Houdini, and then use those assets inside of UE4.

- [Documentation](https://www.sidefx.com/docs/unreal/)
- [Source Code](https://github.com/sideeffects/HoudiniEngineForUnreal)
- [Forum](https://www.sidefx.com/forum/51/)
- [Doug's HoudiniEngine Example](https://github.com/drichardson/UE4Examples/tree/master/HoudiniEngine)


I posted a [video tutorial]({{page.youtubeURL}})
about using Houdini scattered primitives to create foliage in UE4.

## Landscapes
- [Houdini Heightfields to Unreal Engine 4 Landscapes](https://www.youtube.com/watch?v=iUGRAbTHynE)
- [Houdini Scattered Primitives to Unreal Engine 4 Foliage](https://www.youtube.com/watch?v=0PjZ9awgdFY)
- [Doug's Houdini Landscape Test](https://github.com/drichardson/UE4Examples/tree/master/HoudiniLandscapeTest)


## Installing from Source

From PowerShell:

```powershell
cd UE4_PROJ_DIR
mkdir Plugins
git clone https://github.com/sideeffects/HoudiniEngineForUnreal.git
cd HoudiniEngineForUnreal
git checkout Houdini17.5-Unreal4.23
```

And then make sure you have enabled the *HoudiniEngine* plugin in your UE4
*uproject* file. You should have an entry in the *Plugins* section like this:

```json
...
"Plugins": [
...
{
    "Name": "HoudiniEngine",
    "Enabled": true
},
...
],
...

```

