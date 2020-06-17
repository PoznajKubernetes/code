# StatefulSets Pod Management Policy
## 110201 

- Plik z StatefulSet `ss-pmp.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkad-ss
spec:
  serviceName: pkad-ss
  podManagementPolicy: Parallel
  selector:
    matchLabels:
      app: pkad-ss
  replicas: 2
  template:
    metadata:
      labels:
        app: pkad-ss
    spec:
      containers:
      - name: pkad-ss
        image: poznajkubernetes/pkad:red
        resources: {}
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          timeoutSeconds: 1
          periodSeconds: 5
          failureThreshold: 3
```

- Aplikacja StatefulSet z pliku `ss-pmp.yml`

    `kubectl apply -f ss-pmp.yml`