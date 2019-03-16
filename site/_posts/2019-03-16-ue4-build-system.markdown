---
layout: post
title: "Unreal Engine 4 Build System Notes"
---
This post contains information about Unreal Build Tool, the Unreal Engine 4 build system. Most of the information you need to know
can be found in the links below to Epic's official documentation. The notes here shed light on aspects that are
less documented.


# Unreal Build Tool
Unreal Build Tool (UBT) reads C# .build.cs and .target.cs files as input to describe what to build. As part of the build process, these C# files are actually themselves compiled into a Rules assembly (a shared library). This 3 steps process of *build.cs > Rules assembly > build* has an extra step than more common build system like [make](https://www.gnu.org/software/make/) which goes from *Makefile > build*.

The compiled Rule assembly for the engine is:

    Engine\Intermediate\Build\BuildRules\UE4Rules.dll

The compiled Rule assembly for your game is:

    Intermediate\Build\BuildRules\YourGameModuleRules.dll

Rule assemblies are only re-built if UBT determines they are out of date, and this is defined by the [RequiresCompilation](https://github.com/EpicGames/UnrealEngine/blob/4.21/Engine/Source/Programs/UnrealBuildTool/System/DynamicCompilation.cs#L35) function. As of UE 4.21, Rule assemblies are rebuilt if:

1. The timestamp of UBT itself is more recent than the Rules assembly, because a new version of UBT might do something different than an older version of UBT, so you have to rebuild the Rule assembly to be safe.
2. The set of build.cs files requested to be built is different than the set of build.cs files previously built. You can view the build.cs files the Rules file was built for in `Engine\Intermediate\Build\BuildRules\UE4RulesSourceFiles.txt`.
3. The timestamp of any build.cs is more recent than the Rule assembly.

## Timestamp Hell

Build systems like UBT that rely on timestamps can have problems when files are copied from machine to machine when the timestamp is preserved. I recently ran into a problem with HoudiniEngine plugin for UE4 that went like this:

- Install version N of HoudiniEngine plugin. This copies files (including a build.cs) to my UE4 engine directory.
- Build my project. At this point UE4Rules.dll is built because the list of build.cs files changed (rule 2 above). Assume the timestamp on UE4Rules.dll is 2019-03-01T00:00:00.
- Update to version N+1 of HoudiniEngine plugin. This again copies files (including a build.cs) to my UE4 engine directory, overriding the previous version. Now assume here the build.cs timestamp is 2019-02-01T00:00:00 (less recent than the UE4Rules.dll timestamp).
- Build my project. At this point UE4Rules.dll IS NOT BUILT because the list of build.cs files has not changed (I already had the houdini build.cs from my previous install) and the timestamp of UE4Rules.dll was already more recent than the houdini build.cs. That is, rule 3 above is NOT triggered as you might expect.

I reported this bug, in particular, to Side FX, but it's a general weakness with UBT, or any build system that relies on filesystem timestamps to invalidate caches. Side FX will have to do something like update the timestamp of the build.cs file after copying it into the UE4 directory in order to force a UE4Rules re-build.

# Build Configuration

If you're [building the engine from source](https://github.com/EpicGames/UnrealEngine) and you want to work on your machine while this is going on, you may want to limit the number of compilation processes on your system. This is done by modifying BuildConfiguration.xml, which should be placed in `Engine\Saved\UnrealBuildTool\BuildConfiguration.xml`.

Here is the BuildConfiguration.xml I used to limit the number of processes:

    <?xml version="1.0" encoding="utf-8" ?>
    <Configuration xmlns="https://www.unrealengine.com/BuildConfiguration">
      <ParallelExecutor>
        <MaxProcessorCount>1</MaxProcessorCount>
      </ParallelExecutor>
    </Configuration>

# Visual Studio Setup for Engine Builds

[Epic's Setting Up Visual Studio for Unreal Engine](https://docs.unrealengine.com/en-us/Programming/Development/VisualStudioSetup) guide covers most of what you need to know, but if you are compiling the engine from source you also need one additional setting: you must limit the maximum number of parallel project builds to 1. When using UBT,
UBT is responsible for parallel builds, not Visual Studio. If you allow Visual Studio to do parallel project builds
then you will be spawning multiple instances of UBT, which leads to problems like logs files being written concurrently by [two separate processes](https://forums.unrealengine.com/development-discussion/engine-source-github/1579567-unrealbuildtool-unable-to-open-log-file-for-writing-because-it-is-being-used-by-another-process). 

To limit Visual Studio, go to Main Menu > Tools > Options, and then set *maximum number of parallel project builds* to 1.

![Max Parallel Project Builds](/assets/posts/ue4-build-system/max-parallel-project-builds.png)


# References
- [Build Configuration](https://docs.unrealengine.com/en-us/Programming/BuildTools/UnrealBuildTool/BuildConfiguration)
- [Build Tools](https://docs.unrealengine.com/en-us/Programming/BuildTools)
- [Epic UE4 Source Code Access Registration](https://www.unrealengine.com/en-US/ue4-on-github) - you must register with Epic to access any of the github links to the UE4 source code.
- [Understanding Unreal Build Tool](https://ericlemes.com/2018/11/23/understanding-unreal-build-tool/)
- [Unreal Build Tool Source Code](https://github.com/EpicGames/UnrealEngine/tree/master/Engine/Source/Programs/UnrealBuildTool)
- [Unreal Build Tool](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool) - Responsible for building the engine.
- [Unreal Header Tool](https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealHeaderTool) - Reads UE4 C++ code generates .generated.h headers.
