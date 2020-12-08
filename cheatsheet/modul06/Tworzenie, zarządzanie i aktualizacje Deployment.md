# Tworzenie, zarządzanie i aktualizacje Deployment
## 06.03.02 - Demo - Zarządzanie Deploymentami

- Uruchomienie komendy `kubectl get deploy` zwracającej listę wdrożeń w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get deploy`  

- Uruchomienie komendy `kubectl get rs` zwracającej listę replikasetów w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get rs`

- Uruchomienie komendy `kubectl get pod` zwracającej listę podów w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get pod`
    
- (opcja `--dry-run`) Symulacja wraz z wypisaniem na konsole wdrożenia o nazwie `helloapp-crate` (opcja `-o`) w formacie `yaml` i (opcja `--image`) na podstawie obrazu `poznajkubernetes/helloapp:svc`

    `kubectl create deployment helloapp-crate --image=poznajkubernetes/helloapp:svc --save-config --dry-run -o yaml`
    
- Utworzenie wdrożenia o nazwie `helloapp-crate` (opcja `--image`) na podstawie obrazu `poznajkubernetes/helloapp:svc` (opcja `--save-config`) zapisuje bazową konfigurację

    `kubectl create deployment helloapp-crate --image=poznajkubernetes/helloapp:svc --save-config --dry-run -o yaml`
    
- Usuwa pod o nazwie `helloapp-create-5c56d565-59m66`

    `kubectl delete pod helloapp-create-5c56d565-59m66`
    
- Usuwa wdrożenia o nazwie `helloapp-create`

    `kubectl delete deploy helloapp-create`

- (opcja `--dry-run`) Symulacja wraz z wypisaniem na konsole wdrożenia o nazwie `helloapp-crate` (opcja `-o`) w formacie `yaml` i (opcja `--image`) na podstawie obrazu `poznajkubernetes/helloapp:svc` (opcja `--replicas`) o dwóch replikach wraz (opcja `--expose`) z serwisem (opcja `--port`) na porcie 8080

    `kubectl run helloapp-crate --image=poznajkubernetes/helloapp:svc --replicas=2 --restart=Always --save-config --expose --port=8080 --dry-run -o yaml`
    
- Utworzenie wdrożenia o nazwie `helloapp-crate` (opcja `--image`) na podstawie obrazu `poznajkubernetes/helloapp:svc` (opcja `--replicas`) o dwóch replikach wraz (opcja `--expose`) z serwisem (opcja `--port`) na porcie 8080

    `kubectl run NAME --image=IMAGE --replicas=2 --restart=Always --save-config --expose --port=8080`
    
- Plik z konfiguracją wdrożenia `helloapp-dep.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-dep
spec:
  replicas: 2
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
        livenessProbe:
          httpGet:
            path: /
            port: 8080
        readinessProbe:
          httpGet:
            path: /
            port: 8080
        ports:
        - containerPort: 8080
```

- Aplikacja wdrożenia z pliku `helloapp-dep.yml`

    `kubectl apply -f helloapp-dep.yml`
    
- Wypisuje historię wdrożenia `helloapp-dep`

    `kubectl rollout history deploy helloapp-dep`
    
- Przywrócenie poprzedniego wdrożenia `helloapp-dep`

    `kubectl rollout undo deploy helloapp-dep`
    
- Przywrócenie rewizji 3 z wdrożenia `helloapp-dep`

    `kubectl rollout undo deploy helloapp-dep --to-revision=3`
    
- Aktualizuje obrazu podów z wdrożenia `helloapp-dep`

    `kubectl set image deploy helloapp-dep --helloapp-dep=poznajkubernetes/pkad`

- Aktualizuje obraz podów z wdrożenia (opcja `--record`) `true` zapisuje komendę, która wywołała zmianę

    `kubectl set image deploy helloapp-dep --helloapp-dep=poznajkubernetes/pkad --record=true`

- Usuwanie wdrożenia z pliku `helloapp-dep.yml`

    `kubectl delete -f helloapp-dep.yml`   
    
- Status wdrożenia `helloapp-dep`

    `kubectl rollout status deploy helloapp-dep` 
    
- Plik z konfiguracją wdrożenia `helloapp-dep.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-dep-expression
spec:
  replicas: 2
  selector:
    matchExpressions:
      - key: env
        operator: NotIn
        values:
          - prod
      - key: pk
        operator: Exists
      - { key: app, operator: In, values: [ helloapp-dep-expression ] }
  template:
    metadata:
      labels:
        app: helloapp-dep-expression
        env: tst
        pk: "true"
    spec:
      containers:
      - name: helloapp-dep-expression
        image: poznajkubernetes/helloapp:svc
        ports:
        - containerPort: 8080
```