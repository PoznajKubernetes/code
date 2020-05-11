# Podstawowe strategie wdrożeń: recreate i rolling update
## 06.04.02

- Plik z konfiguracją wdrożenia `recreate.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pkad
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: pkad
  template:
    metadata:
      labels:
        app: pkad
    spec:
      containers:
      - name: pkad
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
        env:
        - name: version
          value: v1
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 20
          timeoutSeconds: 1
          periodSeconds: 10
          failureThreshold: 3
```

- Aplikacja wdrożenia z pliku `recreate.yaml`

    `kubectl apply -f recreate.yaml`
    
- Polecenie wyświetla listę wdrożeń 

    `kubectl get deployments` 
    
- Polecenie wyświetla listę podów

    `kubectl get pods`
    
## 06.04.05

- Plik z konfiguracją wdrożenia `slow-update.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pkad
spec:
  replicas: 3
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  selector:
    matchLabels:
      app: pkad
  template:
    metadata:
      labels:
        app: pkad
    spec:
      containers:
      - name: pkad
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
        env:
        - name: version
          value: v1
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 20
          timeoutSeconds: 1
          periodSeconds: 10
          failureThreshold: 3
```

- Uruchomienie komendy `kubectl get pod` zwracającej listę podów w pętli

    `watch kubectl get pod`
    
- Usuwanie wdrożenia z pliku `slow-update.yaml`

    `kubectl delete -f slow-update.yaml`

- Plik z konfiguracją wdrożenia `fast-update.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pkad
spec:
  replicas: 3
  strategy:
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
    type: RollingUpdate
  selector:
    matchLabels:
      app: pkad
  template:
    metadata:
      labels:
        app: pkad
    spec:
      containers:
      - name: pkad
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
        env:
        - name: version
          value: v1
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 20
          timeoutSeconds: 1
          periodSeconds: 10
          failureThreshold: 3
```

## 06.04.08

- Status wdrożenia `pkad`

    `kubectl rollout status deployment pkad` 

- Wstrzymanie wdrożenia `pkad`

    `kubectl rollout pause deployment pkad`
    
- Polecenie wyświetla listę wdrożenia `pkad` 

    `kubectl get deployments pkad`

- Wyświetlenie szczegółowego stanu wdrożenia `pkad`

    `kubectl describe deployments pkad`
    
- Wznowienie wstrzymanego wdrożenia `pkad`

    `kubectl rollout pause deployment pkad`
    
- Wycofanie wdrożenia `pkad` do rewizji 3

    `kubectl rollout undo deployment pkad --to-revision=3`