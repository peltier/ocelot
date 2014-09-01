## Ocelot

[![Build Status](https://travis-ci.org/pmirror/ocelot.svg?branch=master)](https://travis-ci.org/pmirror/ocelot)

A light-weight high-speed BitTorrent tracker written in C++. Part of the Gazelle Project.

### Building

To build Ocelot, do the following:

1. Copy `src/config.cpp.template` to `src/config.cpp` and change any configurations to match what Gazelle uses. Note: make sure you've loaded the `gazelle.sql` into your database before running Ocelot.

2. Build the project by doing the following:

```
cmake .
make
```

This will create a folder called `bin` and place the `ocelot_server` binary inside.

### Development

Those who would like to run the test suite need to download gmock (currently version 1.7.0) in the immediate parent directory of ocelot, and need to run `cmake . -DBUILD_TESTING=1` to enable the `ocelot_tests` target.

Currently, tests are using `config.cpp` to setup ocelot and run the suite. Please load the sql dump called `snapshot.sql` which is located in the test directory prior to running the test suite, or the majority of the tests will fail.

To build and run the tests, you can use `make ocelot_tests` and run `./bin/ocelot_tests`.

### Dependencies

Ocelot requires the following dependencies:

1. boost::system
2. boost::iostreams
3. boost::asio
3. libev
4. mysql++

By default, CMake will assume these can all be found in `/usr/local/include`,  `/usr/include`, or  `/usr/include/mysql` and libs found in `/usr/local/lib`. These should be the default paths for aptitude and homebrew.

### Platforms

Ocelot has been tested on OSX Mavericks using Clang, Gentoo 64bit, and Ubuntu 12.04/ 14.04 using GCC 4.8.

### License

See LICENSE file in project root.