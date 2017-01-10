# Nextcloud on Kubernetes

## Build containers
docker build -t <TAG> .

## Push containers
docker push <TAG>

## Run on Kubernetes
kubectl apply -f *.yml
