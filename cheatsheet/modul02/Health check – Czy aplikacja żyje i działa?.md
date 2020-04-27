# Health check – Czy aplikacja żyje i działa?
## 02.05.04 Demo healthcheck

- Aplikacja poda na klaster z pliku `pkad-health.yaml`

    `kubectl apply -f pkad-health.yaml`

- Polecenie wyświetla listę podów (opcja `-w`) w pętli

    `kubectl get po -w`

- Mapowanie portów z kontenera do lokalnej maszyny http://localhost:8080

    `kubectl port-forward pkad-health 8080:8080`

- Plik z konfiguracją poda `pkad-health.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad-health
spec:
  containers:
  - name: pkad
    image: poznajkubernetes/pkad:blue
    resources: {}
    ports:
    - containerPort: 8080
    livenessProbe:
      httpGet:
        path: /healthy
        port: 8080
      initialDelaySeconds: 25
      timeoutSeconds: 1
      periodSeconds: 10
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 25
      timeoutSeconds: 1
      periodSeconds: 10
      failureThreshold: 3
```
