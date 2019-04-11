# Minikube镜像制作过程

### 1. 构建基本镜像
```
# docker build -t minikube:base
# docker run --privileged -it minikube:base
```

此时可以正常打开，但是每次启动都需要下载minikube相关的bin文件


### 2. 构建最终版镜像
2.1 启动minikube:base容器

```
# docker run -name minikube --privileged -it minikube:base
```

待相关的文件下载成功，minikube启动完成以后，将minikube容器提交到新的镜像 minikube:middle

```
# docker commit minikube minikube:middle
```

2.2 启动一个minikube:middle容器，并进入执行删除操作

```
# docker run -name minikube_middle --privileged -it minikube:middle /bin/bash
# rm -rf /var/run/docker
```

2.3 提交minikube_middle到新的镜像

```
# docker commit minikube_middle minikube:latest
```
