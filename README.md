# Mustard Engine Sample Project
Mustard engine debug runtime with sample game.

Minimal setup for building Lua scripted games on/for 64 bit Windows with the Mustard engine.
## Usage:
Fork the repo

Rename the project folder and executable to a name of your choice

Start editing [`./assets/scripts/main.lua`](assets/scripts/main.lua)

[Browse the Lua API docs](docs/index.html)

The debug executable contains a Lua REPL console and debug logging
- Press tilde ~ to toggle the console while running the debug executable
- You can use the OS to pipe STDERR into log files. IE `Mustard-SampleProject.exe 2> log.txt`
## File format support:
Images:
- 24 or 32 bit TGA with or without RLE compression
	
Audio:
- wav
- ogg
## Deployment:
Deployment is not supported quite yet.
	
But! Here's what happens:

All files in the assets folder (recursively) are compiled into a custom format by the engine's
asset compiler.	*Everything* is compiled in so you'll want to keep Work In Progress stuff in a
separate folder.
		
The game needs to built from C++ code, linked against the Mustard release-mode static library,
and it needs to load the asset library.
## License
Distributed under the zlib License. See [`LICENSE.txt`](LICENSE.txt) for more information.
## Contact
Andrew Krause - ajkrause@gmail.com

Project Link: [https://github.com/scgrn/Mustard-SampleProject](https://github.com/scgrn/Mustard-SampleProject)

---

Have fun!
