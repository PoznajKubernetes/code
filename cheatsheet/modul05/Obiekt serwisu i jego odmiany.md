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

- Plik z konfiguracją poda `pod-to-pod.yaml`
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