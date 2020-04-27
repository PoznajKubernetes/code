# Obiekt serwisu i jego odmiany
## 05.02.02

- Plik z konfiguracją poda `container-to-container.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: helloapp
  labels:
    app: helloapp
spec:
  containers:
  - name: helloapp
    image: poznajkubernetes/helloapp:svc
    resources: {}
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
  - name: tools
    image: giantswarm/tiny-tools
    resources: {}
    command: ["/bin/sh"]
    args: ["-c", "sleep 3600"]
```
- Aplikacja poda z pliku `container-to-container.yaml`

    `kubectl apply -f container-to-container.yaml`
    
- Polecenie wyświetla listę podów

    `kubectl get pod`
    
- Wejście do linii poleceń (opcja `-it`) w trybie interaktywnym (opcja `-c`) w kontenerze `tools` w podzie

    `kubectl exec -it helloapp -c tools sh`
    
## 05.02.04

- Plik z konfiguracją podów `pod-to-pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: helloapp
  labels:
    app: helloapp
spec:
  containers:
  - name: helloapp
    image: poznajkubernetes/helloapp:svc
    resources: {}
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:
  name: tools
  labels:
    app: tools
spec:
  containers:
  - name: tools
    image: giantswarm/tiny-tools
    resources: {}
    command: ["/bin/sh"]
    args: ["-c", "sleep 3600"]
```

- Polecenie wyświetla listę podów (opcja `-o` ) `wide` wraz z adresem IP 

    `kubectl get pods -o wide`
    
- Wyświetlenie szczegółowego stanu poda `helloapp`

    `kubectl describe pod helloapp`
    
- Polecenie wyświetla listę nodów w klastrze

    `kubectl get nodes`

## 05.02.07    

- Plik z konfiguracją podaów `svc-helloapp.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: helloapp-instance-1
  labels:
    app: helloapp
spec:
  containers:
  - name: helloapp
    image: poznajkubernetes/helloapp:svc
    resources: {}
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:
  name: helloapp-instance-2
  labels:
    app: helloapp
spec:
  containers:
  - name: helloapp
    image: poznajkubernetes/helloapp:svc
    resources: {}
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
```

- Plik z konfiguracją serwisu `svc-clusterip-port.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp-port
spec:
  selector:
    app: helloapp
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
```
- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    `kubectl get services`

- Plik z konfiguracją serwisu `svc-clusterip-namedport.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp
spec:
  selector:
    app: helloapp
  type: ClusterIP
  ports:
  - name: http
    port: 8080
    targetPort: http
```

- Plik z konfiguracją serwisu `svc-clusterip-multi-port.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp-multiport
spec:
  selector:
    app: helloapp
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
  - name: http-8090
    port: 8090
    targetPort: 8080
    protocol: TCP
```

## 05.02.10

- Plik z konfiguracją serwisu `svc-nodeport.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp
spec:
  selector:
    app: helloapp
  type: NodePort
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
```

- Plik z konfiguracją serwisu `svc-nodeport-port.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp
spec:
  selector:
    app: helloapp
  type: NodePort
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
    nodePort: 32000
```

## 05.02.12

- Plik z konfiguracją serwisu `svc-nodeport-port.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: helloapp
spec:
  selector:
    app: helloapp
  type: LoadBalancer
  ports:
  - name: http
    port: 80
    targetPort: 8080
    protocol: TCP
```

- Wyświetlenie szczegółowego stanu serwisu `helloapp`

    `kubectl describe svc helloapp`
    
## 05.02.15

- Plik z konfiguracją serwisu i endpointu `endpoint-external.yaml`
```yaml
kind: Service
apiVersion: v1
metadata:
  name: external-web
spec:
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80 
---
kind: Endpoints
apiVersion: v1
metadata:
  name: external-web
subsets: 
  - addresses:
    - ip: 1.1.1.1
    ports:
      - port: 80 
        name: http
```

- Wejście do linii poleceń (opcja `-it`) w trybie interaktywnym w podzie `tools`

    `kubectl exec -it tools sh`