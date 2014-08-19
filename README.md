## Ocelot

A light-weight high-speed BitTorrent tracker written in C++. Part of the Gazelle Project.

### Building

To build Ocelot, do the following:

1. Copy `src/config.cpp.template` to `src/config.cpp` and change any configurations to match what Gazelle uses. Note: make sure you've loaded the `gazelle.sql` into your database before running Ocelot.

2. Build the project by doing the following:

```
cmake .
make
```

This will create a folder called `bin` and place the `ocelot` binary inside.

### Dependencies

Ocelot requires the following dependencies:

1. boost::system
2. boost::iostreams
3. boost::asio
3. libev
4. mysql++

By default, CMake will assume these can all be found in `/usr/local/include`,  `/usr/include`, or  `/usr/include/mysql` and libs found in `/usr/local/lib`. These should be the default paths for aptitude and homebrew.

### Platforms

Ocelot has been tested on OSX Mavericks using Clang, and Ubuntu 14.04 using GCC 4.8.

### License

See LICENSE file in project root.