# Wpływ Readiness na Service
## 05.04.02 - Wpływ Readiness Probe na Service
              
- Plik z konfiguracją podami `pkads.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad-01
  labels:
    name: pkad-01
    app: pkad
spec:
  containers:
  - name: pkad-01
    image: poznajkubernetes/pkad
    livenessProbe:
      httpGet:
        path: /healthy
        port: pkad-01
      initialDelaySeconds: 3
      periodSeconds: 3
    readinessProbe:
      httpGet:
        path: /ready
        port: pkad-01
      initialDelaySeconds: 3
      periodSeconds: 3
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - name: pkad-01
        containerPort: 8080
---
apiVersion: v1
kind: Pod
metadata:
  name: pkad-02
  labels:
    name: pkad-02
    app: pkad
spec:
  containers:
  - name: pkad-02
    image: poznajkubernetes/pkad
    livenessProbe:
      httpGet:
        path: /healthy
        port: pkad-02
      initialDelaySeconds: 3
      periodSeconds: 3
    readinessProbe:
      httpGet:
        path: /ready
        port: pkad-02
      initialDelaySeconds: 3
      periodSeconds: 3
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - name: pkad-02
        containerPort: 8080
```

- Plik z konfiguracją serwisu `pkad-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: pkad-service
spec:
  selector:
    app: pkad
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
```

- Utworzenie obiektu z pliku `pkads.yml`

    `kubectl create -f pkads.yml`
    
- Polecenie wyświetla listę podów

    `kubectl get pods`

- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    
- Mapowanie portów z kontenera do lokalnej maszyny http://localhost:8080

    `kubectl port-forward pkad-01 8080:8080`
    
- Polecenie wyświetla listę endpointów (opjca `-w`) w pętli

    `kubectl get endpoints -w`