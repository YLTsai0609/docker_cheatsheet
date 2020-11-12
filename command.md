01. `docker xxx --help` - show help information
02. `docker image ls` - show all the docker images
3. `docker ps -all (docker container ls)` - show all the docker containers
4. `docker build -t image_name:version .` - build an image from a Dockerfile with name and version(you should have Dockerfile in your work directory)
5. `docker run --publish 8000:8080 --detach --name container_name image_name` - run a image with a container in the background(detach) forward local machine port 8000 to docker private port 8080
06.  `docker run -it image_id /bin/sh` - run a container and get interactive shell
07.  `docker exec -it container_name /bin/bash` - run a bash shell with iteracitve mode with your running container
08. `docker run --runtime=nvidia --shm-size 1g image_id` - run the container (using nvidia driver), with shared memory 1G
09.    `docker stop container_name` - stop the running container

10.  `docker rm --force container_name` - stop the container and delete the container
11.  `docker cp your_local_file container_id:/home/`
12.  `docker volume ls` - list docker volume on your local file system.
13.  `docker volume create --name volume_name` - create a volume so that you can get the data from the container.
