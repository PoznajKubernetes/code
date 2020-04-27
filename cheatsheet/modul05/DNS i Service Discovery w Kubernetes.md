# DNS i Service Discovery w Kubernetes
## 05.03.02

- Plik z konfiguracją poda i serwisu `app.yaml`
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
    port: 80
    targetPort: http
```

- Aplikacja poda na klaster z pliku `app.yaml`

    `kubectl apply -f app.yaml`
    
- Polecenie wyświetla listę podów

    `kubectl get pod`
    
- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    
- Wejście do linii poleceń (opcja `-it`) w trybie interaktywnym w podzie `tools`

    `kubectl exec -it tools sh`
    
- Utworzenie namespace `demo`

    `kubectl create ns demo`
    
- Aplikacja poda na klaster z pliku `app.yaml` (opcja `-n`) w namespace `demo`

    `kubectl apply -f app.yaml -n demo`
    
- Polecenie wyświetla listę serwisów (opcja `-n`) w namespace `demo`

    `kubectl get svc -n demo`
    
- Utworzenie poda (opcja `--generator`) przy użyciu generatora `run-pod/v1` (opcja `-it`) w trybie interaktywnym (opcja `--image`) z obrazu `giantswarm/tiny-tools` (opcja `-n`) w namespace `demo` który po zakończeniu działania zostanie usunięty (opcja `--rm`)

    `kubectl run -it --rm tools --generator=run-pod/v1 --image=giantswarm/tiny-tools -n demo`