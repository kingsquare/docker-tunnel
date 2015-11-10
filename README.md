# Tunnel

This is a `simple` ssh-tunnel container for easily connecting to other containers / servers elsewhere via a ```--link```-ed
tunnel container. This tunnel will use your local SSH-agent to connect to the endpoint thus no need to push your ~/.ssh/ files into
the image.

# Usage

The full syntax for starting an image from this container:

	docker run -d --name [$your_tunnel_name] -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:[$exposed_port]:[$destination]:[$destination_port] [$user@][$server]

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

* 2015-11-10

    Thanks to @ignar I took another look at the dockerfile and have updated it to use [AlpineLinux](http://www.alpinelinux.org/) 
    This results in a _much_ smaller image (<8mb) and is still just as fast and functional. 
    Thanks @ignar for bringing this container back to my attention :)