# Czym jest ReplicaSet?
## 06.01.02 - ReplicaSet Demo

- Plik z konfiguracją replicaset `replica-set.yaml`
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: pkad-rs
  labels:
    app: demo-rs
    tier: pkad-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: pkad-rs
  template:
    metadata:
      labels:
        tier: pkad-rs
    spec:
      containers:
      - name: pkad
        image: poznajkubernetes/pkad:blue
```

- Aplikacja replicaset na klaster z pliku `replica-set.yaml`

    `kubectl apply -f replica-set.yaml`
    
- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get po -w`
    
- Wypisanie konfiguracji poda `pkad-rs-lc9tn` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get po pkad-rs-lc9tn -o yaml`
    
- Mapowanie portów z poda do lokalnej maszyny http://localhost:8080

    `kubectl port-forward pkad-rs-lc9tn 8080:8080`
    
- Usunięcie poda `pkad-rs-lc9tn` z klastra

    `kubectl delete po pkad-rs-lc9tn`
