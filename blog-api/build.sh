serverIP="59.111.60.138"
loginUser="root"
# ssh $loginUser@$serverIP docker ps

# 开始打包镜像
docker build -t blog-api .

# 镜像上传阿里云镜像仓库
images_id=`docker images | grep blog-api | grep -v k8s_google_containers | awk '{print $3}'`
echo $images_id
docker tag $images_id registry.cn-beijing.aliyuncs.com/k8s_google_containers/blog-api:latest
docker push registry.cn-beijing.aliyuncs.com/k8s_google_containers/blog-api:latest

# 开始部署镜像
ssh $loginUser@$serverIP "docker pull registry.cn-beijing.aliyuncs.com/k8s_google_containers/blog-api:latest"
ssh $loginUser@$serverIP "docker rm -f blog-api"
ssh $loginUser@$serverIP "docker run -d -p 8888:8888 --name blog-api --net=host registry.cn-beijing.aliyuncs.com/k8s_google_containers/blog-api:latest"

