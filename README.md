# Vapor Example

Clone this repo and run `swift build` to download the dependencies, then run `.build/debug/MyApp`

View [Vapor](https://github.com/tannernelson/vapor) for documentation.

Swift 2.2 or later is required.

Works on Ubuntu.

### Deploying

To deploy to Ubuntu 14.04 LTS (without Swift installed on remote server).

1. Compile program on Ubuntu 14.04 (Swift must be installed on this computer)
2. Copy program from `.build/[debug,release]/VaporApp` into `Deploy/VaporApp`
3. Copy contents of `Deploy` folder to remote Ubuntu 14.04 server (the folder contains all shared libs needed for running)
4. Run `./run.sh`
