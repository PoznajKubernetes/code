# Skalowanie aplikacji
## 06.05.04 - Demo - Skalowanie Manualne

- Plik z konfiguracją wdrożenia `helloapp-dep.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-dep
spec:
  selector:
    matchLabels:
      app: helloapp-dep
  template:
    metadata:
      labels:
        app: helloapp-dep
    spec:
      containers:
      - name: helloapp-dep
        image: poznajkubernetes/helloapp:svc
        ports:
        - containerPort: 8080
```

- Uruchomienie komendy `kubectl get deploy` zwracającej listę wdrożeń w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get deploy`  

- Uruchomienie komendy `kubectl get rs` zwracającej listę replikasetów w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get rs`

- Uruchomienie komendy `kubectl get pod` zwracającej listę podów w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get pod`
    
- Aplikacja wdrożenia z pliku `helloapp-dep.yml`

    `kubectl apply -f helloapp-dep.yml`
    
- Wyskalowanie wdrożenia `helloapp-dep` (opcja `--replicas`) do 3 instancji

    `kubectl scale deployment helloapp-dep --replicas=3`
    
- Aplikacja wdrożenia z pliku `helloapp-dep.yml` (opcja `--record`) `true` zapisuje komendę, która wywołała zmianę

    `kubectl apply -f helloapp-dep.yml --record`
    
- Wypisuje historię wdrożenia `helloapp-dep`

    `kubectl rollout history deploy helloapp-dep`
    
- Wypisuje szczegóły wdrożenia `helloapp-dep` (opcja `--revision`) wersji pierwszej

    `kubectl rollout history deploy helloapp-dep --revision=1`   