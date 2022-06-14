#!/bin/bash

# 创建容器
docker run -d --name es-cert docker.elastic.co/elasticsearch/elasticsearch:7.15.0 sleep 3600
# 生成证书
docker exec es-cert /usr/share/elasticsearch/bin/elasticsearch-certutil cert -out /elastic-certificates.p12 -pass ""
# 拷贝证书
docker cp es-cert:/elastic-certificates.p12 ./
# 关闭并删除容器
docker stop es-cert && docker rm es-cert
# 导入证书到k8s
kubectl create secret generic elastic-certificates --from-file=./elastic-certificates.p12 -n common
# 创建账号密码 Secret
kubectl create secret generic elastic-credentials --from-literal=username=elastic --from-literal=password=1qT8L8DMh92KUw== -n common
# 查看 Secret 列表
kubectl get secret -n common
# 查看内部通信证书 Secret
kubectl describe secret elastic-certificates -n common
# 查看账号密码 Secret
kubectl describe secret elastic-credentials -n common
