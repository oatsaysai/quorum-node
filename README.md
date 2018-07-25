# How to run

## Build docker image
```sh
docker build -t quorum -f docker/Dockerfile .
docker build -t quorum-api -f docker/Dockerfile-api .
```

## Docker compose up
```sh
docker-compose -f docker/docker-compose.yml up
docker-compose -f docker/docker-compose-api.yml up
```

## Load test
 - use loadtest project
 ```sh
 # clone from https://github.com/the-hulk-id/loadtest
 # Example how to use loadtest
node loadtest.js -d 10 -m 10 -s 0 -a 127.0.0.1,8181,127.0.0.1,8182,127.0.0.1,8183,127.0.0.1,8184,127.0.0.1,8185,127.0.0.1,8186
 ```