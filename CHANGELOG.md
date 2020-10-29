# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## (2017-01-27)

   - Update image to use the `alpine:3.5`
   - Use `autossh` instead of simple `ssh` for extra stability of the tunnel
   - Provided sample `Makefile` to automate the build process -- on
     unix-like systems you can use make command to build docker image and
     container.

	```SSH_CMD="*:6379:localhost:6379 martin@172.17.0.1" make build-container```

   - The assumption is, that local `ssh-agent` holds the required identity
     files.  Another solution may be to generate new ssh key (`ssh-keygen`)
     and use the ssh `-i` option to provide the identity directly.

## (2016-09-13)

    Thanks to @phlegx we now have a seperate tag for reversed tunnels (remote -> local)
    This adds the following tags to this repo:
    - `kingsquare/tunnel:latest` (the `-L` option)
    - `kingsquare/tunnel:forward`
    - `kingsquare/tunnel:l`

    and the reverse option: (the `-R` option)
    - `kingsquare/tunnel:reverse`
    - `kingsquare/tunnel:r`

    Thanks @ignar for bringing this container back to my attention :)

## (2015-11-10)

    Thanks to @ignar I took another look at the dockerfile and have updated it to use [AlpineLinux](http://www.alpinelinux.org/)
    This results in a _much_ smaller image (<8mb) and is still just as fast and functional.
    Thanks @ignar for bringing this container back to my attention :)
