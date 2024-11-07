![example workflow](https://github.com/JamieDStewart/GBA_template/actions/workflows/cmake-multi-platform.yml/badge.svg)

# GBA_template

This is a repository demonstrating how to implement a basic Game Boy Advance development setup using Visual Studio Code with no dependencies on any existing libraries using the ARM Toolchain and CMake.
This repository additoinally uses GitHub Actions to demonstrate how these can be used with a GBA project to help maintain the stability of the build. I will look to add tests to this in the future as I learn more about using GitHub actions myself, for now I'm pleased that I can get this project to build on both Unix and Windows from a github action.
Feel free to use this repo as a jumping off point for your own GBA development projects.

##Dependencies

To build this project you will need the ARM Embedded Toolchain which can be downloaded from ARM here [Arm GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) the latest release of the ARM GNU toolchain should work just fine.
Once you have installed the toolchain to compile everything you will need to set an environment variable called **ARM_NONE_EABI_GCC_PATH** for the path to the Toolchain directory. You could follow this video on [how to set an environment variable](https://www.youtube.com/watch?v=5BTnfpIq5mI) or you could run *setx* from the command line.

```
setx ARM_NONE_EABI_GCC_PATH %where_you_installed_the_ARM_GNU_Toolchain%
```

Building the project requires the use of [CMake](https://cmake.org/download/) and [Ninja](https://github.com/ninja-build/ninja/releases). These can be installed from their respective links, once Ninja is installed you should add it to the PATH environment variable so that it will be picked up in the CMake build process for the project.

### VS Code Extensions

To make everything a bit nicer in VS code there are a couple of extensions that you will need to have installed:
  [ARM Extension](https://github.com/dan-c-underwood/vscode-arm)
  [C/C++](https://github.com/Microsoft/vscode-cpptools)
  [C++ Intellisense](https://github.com/austin-----/code-gnu-global)
  [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake)
  [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

##Emulators 

Unless you're going to build the rom and put it straight onto a physical GBA you will need to make use of an emulator for testing and debugging purposes. I recommend using [mGBA](https://mgba.io/) as it has a GDB debugging stub and this repository is set up to allow that to be used (on Windows -- sorry to those of you on Unix, though I will implement Unix support on this repo).  Another good GBA Emulator that allows debugging in ASM is [No$GBA](https://www.nogba.com/) and I find for graphically debugging whats going on in various background tile layers and sprite layers that no$GBA has a nice interface.

**Note:** There is a batch file that's set to run when a build is launched from VS Code that launches mGBA with the debugging flag enabled and the built GBA binary. For this to work properly you'll need to have added the folder you installed mGBA to the PATH environment variable on your system.
```
"debugServerPath": "${workspaceFolder}/_build_tools/launchMGBA.bat",
"debugServerArgs": "${workspaceFolder}/build GBA_template.elf",
```
### .vscode file modifications

**tasks.json** - This file contains a couple of tasks that I find handy that you can delete if you choose to, the first one is a **stop emulation** task that calls taskkill to terminate the mGBA process, this is a windows only task so won't work on Unix or Mac. Then there's **run** label I sometimes use No$GBA as the source debugger is pretty great, you mightneed to modify it to look for no$GBA.exe in the correct location.

## Debugging the Game
Once all of the above has been squared away you should be able to make this project.

*Step 1:* Run the CMake Configuration by pressing ctrl+shift+p and selecting CMake:Configure. Read any output messages, to make sure there are no errors. If there are any ensure that you have the correct environment variables set up and that all dependencies are installed.
*Step 2:* Once CMake is configured then you can build the project by pressing ctrl+shift+p and selecting CMake:Build. This will fire off the build process and hopefully you'll get a build folder and a GBA_template.elf and GBA_template.gba file produced at the end of the build process.
*Step 3:* Debugging the GBA rom. Press F5 to begin debugging, if all your paths are set up you should be good to go. You should then be presented with a debug view, where you can navigate through the code line by line and track individual values and memory addresses, set breakpoints and generally figure out what the code is doing!




