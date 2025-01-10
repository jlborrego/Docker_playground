# Introduction 

This repo is used to provide a Docker Hub registry.

Extracted from https://docs.docker.com/registry/deploying/

# Start the registry

To start the registry just run the following command:

```
./start.sh <registry local ip> <registry port> <username> <password>
```

For example:

```
./start.sh 127.0.0.1 5000 admin admin
```

Or:

```
./start.sh localhost 5000 admin admin
```

This will start the registry on the local machine and now its ready to be used.
Next, what you need to do is login to the Docker Hub registry.

# Login to this registry

To log in to the Docker Hub registry you need to run the following command:

```
docker login admin@localhost:9000
```

This will provide you access to the Docker Hub registry and you can push now some images!

# Push a image

Before starting a test you need to start a registry.

You can check and run the test script with:

```
./test.sh <registry local ip> <registry port> <username> <password>
```

This script will pull a image from official Docker Hub and then push it to the registry as `my-ubuntu`. Then it will pull again the image from the registry to check uploads and downloads.

If its the first time you run the test script or you did not run the login command, it will ask you for credentials.

# Stop the registry

To stop the registry just run the following command:

```
./stop.sh
```

# Considerations

This registry does not support removing images. To do it you must configure it: https://docs.docker.com/registry/configuration/#delete

# Use the docker registry from other machine

To use the docker registry you need to add the registry's certificate to your machine. To do that, you need to run the following command:

```
./userScripts/addDockerRegistry.sh <docker hub ip> <docker hub port> <cert file>
```

For example:

```
./userScripts/addDockerRegistry.sh 127.0.0.1 5000 cert/selfsigned.crt
```

This needs the certificate file, so you need to get that file into your machine first.

You can remove that certificate with the following command:

```
./userScripts/removeDockerRegistry.sh <docker hub ip> <docker hub port>
```

For example:

```
./userScripts/removeDockerRegistry.sh  127.0.0.1 5000 cert/selfsigned.crt
```
