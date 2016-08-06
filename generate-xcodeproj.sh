#!/bin/bash

# This builds the project using the proper dependencies.
# TODO: When using `vapor build` and `vapor xcode`, add these flags if there's a `--mysql` flag

swift package generate-xcodeproj -Xswiftc -I/usr/local/include/mysql -Xlinker -L/usr/local/lib
