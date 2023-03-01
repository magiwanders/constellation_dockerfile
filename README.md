# [Constellation](https://constellation.readthedocs.io/en/latest/index.html) Dockerfile
Dockerfile for the [Constellation RTL NoC generator framework docker image](https://hub.docker.com/r/magiwanders/constellation). 

Build an image:

> :warning: **This builds the image with its current DockerHub name and version `magiwanders/constellation:x.x`. If you want to publish your own fork modify the first line of the Makerfile.**

```
make 
```

Create non-volatile container and run it:

```
make container
make start
```

Remove container:
```make clean```

Remove container and image:
```make uninstall```

### Testing
Tests available:
- ```TestConfigXX``` where XX ranges from 00 to 72 -> functional correctness tests.
- ```TLTestConfigXX``` where XX ranges from 00 to 06 -> TileLink protocol tests.
- ```AXI4TestConfigXX``` where XX ranges from 00 to 03 -> AXI4 protocol tests.

How to re-compile the above tests, assuming the container is NOT already running in the background:

```
make test name=<test_name>
```

This will run the test and put a rendered visualization in the *./renders* folder. Afterwards, the user can use the container shell.

### Traffic Evaluation
Evaluations available:
- ```EvalTestConfigXX``` where XX tanges from 00 to 08.

TODO
