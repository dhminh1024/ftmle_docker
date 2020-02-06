# Setup environment

## Prerequisites

1. Install Docker following the installation guide for your platform: https://docs.docker.com/engine/installation/
2. Install [VSCode](https://code.visualstudio.com/), and the [Docker Extension](https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker)

```
docker build -t cs_ftmle .
docker run -it -p 8888:8888 -p 5000:5000 -v $PWD:/home/jovyan/work cs_ftmle start.sh jupyter lab
```