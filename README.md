[![](https://images.microbadger.com/badges/image/kingsquare/tunnel.svg)](https://microbadger.com/images/kingsquare/tunnel "Get your own image badge on microbadger.com")
# Tunnel

This is a `simple` ssh-tunnel container for easily connecting to other containers / servers elsewhere via a ```--link```-ed
tunnel container. This tunnel will use your local SSH-agent to connect to the endpoint thus no need to push your ~/.ssh/ files into
the image.

# Usage

The full syntax for starting an image from this container:

	docker run -d --name [$your_tunnel_name] -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:[$exposed_port]:[$destination]:[$destination_port] [$user@][$server]

**Mac support:** ~~Please be aware that with the launch of the [Docker for Mac Beta](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/) this currently doesnt work on Mac.~~ Please see this [note](https://github.com/kingsquare/docker-tunnel/issues/2#issuecomment-220782052)

# Examples

* you would like to have a tunnel port 3306 on server example.com locally exposed as 3306

	```docker run -d --name tunnel_mysql -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:3306:localhost:3306 me@example.com```

* you would like to have a tunnel port 3306 on server example.com locally exposed on the host as 3308

	```docker run -d -p 3308:3306 --name tunnel_mysql -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:3306:localhost:3306 me@example.com```


# Using as an Ambassador

This method allows for using this image as an ambassador to other (secure) servers:

	docker stop staging-mongo;
	docker rm staging-mongo;
	docker run -d --name staging-mongo -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:2222:127.0.0.1:27017 tunnel-user@db.staging

	docker stop production-mongo;
	docker rm production-mongo;
	docker run -d --name production-mongo -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:2222:127.0.0.1:27017 tunnel-user@db.production

use the links in another container via exposed port 2222:

	docker run --link staging-mongo:db.staging \
	    --link production-mongo:db.production \
	    my_app start

# Changelog

* 2017-01-27

   - Update image to use the `alpine:3.5`
   - Use `autossh` instead of simple `ssh` for extra stability of the tunnel
   - Provided sample `Makefile` to automate the build process -- on
     unix-like systems you can use make command to build docker image and
     container.

	```SSH_CMD="*:6379:localhost:6379 martin@172.17.0.1" make build-container```

   - The assumption is, that local `ssh-agent` holds the required identity
     files.  Another solution may be to generate new ssh key (`ssh-keygen`)
     and use the ssh `-i` option to provide the identity directly.

* 2016-09-13

    Thanks to @phlegx we now have a seperate tag for reversed tunnels (remote -> local)
    This adds the following tags to this repo:
    - `kingsquare/tunnel:latest` (the `-L` option)
    - `kingsquare/tunnel:forward`
    - `kingsquare/tunnel:l`

    and the reverse option: (the `-R` option)
    - `kingsquare/tunnel:reverse`
    - `kingsquare/tunnel:r`

    Thanks @ignar for bringing this container back to my attention :)

* 2015-11-10

    Thanks to @ignar I took another look at the dockerfile and have updated it to use [AlpineLinux](http://www.alpinelinux.org/)
    This results in a _much_ smaller image (<8mb) and is still just as fast and functional.
    Thanks @ignar for bringing this container back to my attention :)
