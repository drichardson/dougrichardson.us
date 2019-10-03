---
layout: note
title: Houdini
date: 2019-10-03 12:58:04 -0700
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

## Landscapes

Houdini [Heightfields](https://www.sidefx.com/docs/houdini/nodes/sop/heightfield.html) can be used to
generate UE4 [Landscapes](https://docs.unrealengine.com/en-US/Engine/Landscape/Creation/index.html). Generating terrain in Houdini is similar to [World Machine](https://www.world-machine.com/) since they are both node based.

One nice thing about Houdini is the ability to insert Python nodes and VEX Attribute Wrangler nodes to
write custom programs that modify the height field.

- [Houdini Heightfields to Unreal Engine 4 Landscapes](https://www.youtube.com/watch?v=iUGRAbTHynE)
- [Houdini Scattered Primitives to Unreal Engine 4 Foliage](https://www.youtube.com/watch?v=0PjZ9awgdFY)
- [Doug's Houdini Landscape Test](https://github.com/drichardson/UE4Examples/tree/master/HoudiniLandscapeTest)


# Houdini Digital Assets (HDAs)

From [Houdini Digital Assets](https://www.sidefx.com/docs/houdini/assets/index.html):

> Digital assets let you create reusable nodes and tools from existing networks.

These tools can be reused in Houdini itself and also by HoudiniEngine,
which has plugins for UE4, Maya, and other tools.

## Embedding Assets
You may need to reference external content (i.e., JPEGs, XML, JSON, FBX) in your HDA. However,
if you distribute your HDA wihtout the external content, your tool will not work. To deal with this
issue, you can embed the file in the Operator Type Properties window's [Extra Files](https://www.sidefx.com/docs/houdini/ref/windows/optype.html#extra_files) tab. You can then refer to these embedded files using [opdef:](https://www.sidefx.com/docs/houdini/assets/opdef.html) (also see [Specifying files inside an asset using opdef:](https://www.sidefx.com/docs/houdini/assets/create.html#sections)).


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

