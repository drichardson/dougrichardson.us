---
layout: note
title: Houdini
date: 2019-10-04 21:14:50 -0700
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

## Installing from Github Sources
The Game Development Toolset is released frequently (usually at least once a week), but if you want to
have the very latest version, or you want to make changes yourself, you will want to install from
[Github sources](https://github.com/sideeffects/GameDevelopmentToolset)
rather than use the updater tool (in the Game Development Toolbar in the Games shelf).

To install from Github sources:

1. Uninstall the Game Dev Tools, if you have already installed them.
1. Checkout the sources: 
```bash
git clone https://github.com/sideeffects/GameDevelopmentToolset.git
```
1. Add the full path to the checked out sources to the `HOUDINI_PATH` variable in
[houdini.env](https://www.sidefx.com/docs/houdini/basics/config_env#setting-environment-variables). For example:
```ini
HOUDINI_PATH = E:\code\GameDevelopmentToolset;$HOUDINI_PATH;&
```
1. Restart Houdini. You should now be able to access the tools in the Game Dev Toolset.

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

The Python documentation has a good description of this in [hou.HDASection class](https://www.sidefx.com/docs/houdini/hom/hou/HDASection.html), which you can also view in the Python Shell with `help(hou.HDASection)`:

> # hou.HDASection
>
> Represents a *section* of data stored along with a digital asset.
>
> A digital asset stores its contents in a number of different pieces of
> data called sections. Each section is named and contains an arbitrarily
> sized piece of data, often textual. Each section is like a file embedded
> inside the definition, and Houdini uses specially named sections to
> store the node contents, list of parameters, etc. You can embed your own
> data into a digital asset by putting it inside a section.
>
> Any parameter in Houdini that references a file can also reference a
> section inside a digital asset. For example, if car is an object-level
> digital asset and the section is named "texture.jpg", you can reference
> that texture with `opdef:/Object/car?texture.jpg`. Note that hou.readFile
> also supports this opdef: syntax.
>
> By moving files into digital asset sections, you can build self-
> contained digital assets that can be distributed via a single hda file.
>
> Note that section names may contain `/`.

In this example jpeg, json, xml, and text are embedded from the *Extra Files* section of the *Operator Type Properties* window:

![Embedded Assets in Extra Files](/assets/notes/houdini/extra-files.png)

Scripts are added to more easily access the data:

![Embedded Scripts](/assets/notes/houdini/scripts.png)

Finally, the data is accessed from a font node:

![Accessing Scripts from Font Node](/assets/notes/houdini/font.png)

For full example, see [embedded_asset_file.hiplc](https://github.com/drichardson/HoudiniExamples/blob/master/embedded_asset_file.hiplc) (authored in Houdini Indie).

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

