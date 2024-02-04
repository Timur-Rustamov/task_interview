#!/bin/bash

DATE=`date +%Y.%m.%d.%H.%M` 
IMAGE_NAME=nginx
IMAGE_TAG=$DATE 
DOCKERFILE_PATH=./Dockerfile
HELM_CHART_PATH=nginx
KUBE_NAMESPACE=default
RELEASE_NAME=nginx

echo "Введите адрес артифактори, куда вы хотите отправить образ:"
read ARTIFACTORY_URL
echo "Вы ввели: $ARTIFACTORY_URL"

echo "Собираем docker image из докерфайла..."
docker build -t $IMAGE_NAME:$IMAGE_TAG -f $DOCKERFILE_PATH .
echo "Сборка завершена."

echo "Отправляем docker image в артифактори..."
docker tag $IMAGE_NAME:$IMAGE_TAG $ARTIFACTORY_URL/$IMAGE_NAME:$IMAGE_TAG 
docker push $ARTIFACTORY_URL/$IMAGE_NAME:$IMAGE_TAG 
echo "Отправка завершена."

echo "Деплоим helm chart в кубернетес кластер..."
helm upgrade --install $RELEASE_NAME $HELM_CHART_PATH --namespace $KUBE_NAMESPACE --set image.repository=$ARTIFACTORY_URL/$IMAGE_NAME --set image.tag=$IMAGE_TAG 
echo "Деплой завершен."