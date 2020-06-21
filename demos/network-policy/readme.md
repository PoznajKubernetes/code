# https://docs.microsoft.com/en-us/azure/aks/use-network-policies

kubectl create ns np-pk
kubens np-pk
kubectl create deployment pkad --image=poznajkubernetes/helloapp:svc
kubectl expose deployment pkad --port=80 --target-port=8080

alias pk-access='kubectl run access --restart Never --rm -it --image busybox /bin/sh'