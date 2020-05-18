# Wdrożenie Ingress Controller
## 07.02.02 

- Aplikacja ogólnego wdrożenia `ingress-nginx`

    `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml`
    
- Polecenie wyświetla listę wszystkich obiektów w namespace (opcja `-n`) `ingress-nginx`
    
    `kubectl get all -n ingress-nginx`
    
- Polecenie wyświetla listę serwisów w namespace (opcja `-n`) `ingress-nginx`
    
    `kubectl get svc -n ingress-nginx`
    
- Aplikacja `ingress-nginx` docker for mac
  
    `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml`
    
- Plik z konfiguracją testu Ingress `ingress-test.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pk
spec:
  selector:
    matchLabels:
      app: pk
  template:
    metadata:
      labels:
        app: pk
    spec:
      containers:
      - name: demo
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
          name: http
---
kind: Service
apiVersion: v1
metadata:
  name: pk
spec:
  selector:
    app: pk
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: http
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: pk
spec:
  rules:
    - host: localhost
      http:
        paths:
        - backend:
            serviceName: pk
            servicePort: 80
```
`
- Aplikacja obiektów z pliku `ingress-test.yaml`

    `kubectl apply -f ingress-test.yaml`
    
- Wyświetlenie logów `nginx-ingress-controller-7dcc95dfbf-n8fvb` z namespace (opcja `-n`) `ingress-nginx`

    `kubectl logs -n ingress-nginx nginx-ingress-controller-7dcc95dfbf-n8fvb`
    
## 07.02.05 

- Dodanie repozytorium szablonów dla helm

    `helm repo add stable https://kubernetes-charts.storage.googleapis.com/`
    
- Utworzenie namespace `ingress-external`

    `kubectl create ns ingress-external`
    
- Instalacja wdrożenia `ingress-external` z pakietu `stable/nginx-ingress` w namespace (opcja `--namespace`) ingress-external  z parametrami (opcja `--set`)
    - obiekty korzystających z ingress`controller.ingressClass=ingress-external` 
    - dwie repliki - `controller.replicaCount=2`
    - kierowanie zapytań do poda na danym węźle - `controller.service.externalTrafficPolicy=Local`
    - wersja obrazu ingress `0.26.1` - `controller.image.tag=0.26.1`

    `helm install ingress-external stable/nginx-ingress --set controller.ingressClass=ingress-external --set controller.replicaCount=2 --set controller.service.externalTrafficPolicy=Local --set controller.image.tag=0.26.1 --namespace=ingress-external`  
    