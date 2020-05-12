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
    
## 06.05.04 - Demo - HorizontalPodAutoscaler

- Edycja konfiguracji wdrożenia `metrics-server`

    `kubectl edit deploy -n kube-system metrics-server`
    
- Wypisuje zużycie zasobów dla nodów w klastrze

    `kubectl top nodes`
    
- Wypisuje zużycie zasobów dla podów

    `kubectl top pods`
    
- Uruchomienie wdrożenia `ll` (opcja `--image`) na postawie obrazu `k8s.gcr.io/hpa-example` z gwarantowanymi zasobami 0.2 vCPU (opcja `--requests`) wystawieniem portu `80` (opcja `--expose --port`)

    `kubectl run ll --image=k8s.gcr.io/hpa-example --requests=cpu=200m --expose --port=80`

- Automatyczne skalowanie wdrożenia `ll` (opcja `--cpu-percent`) skalowanie powyżej `50%` obciążenia dla minimalnej (opcja `--min`) oraz maksymalnej liczby (opcja `--max`) podów

    `kubectl autoscale deployment ll --cpu-percent=50 --min=1 --max=10`
    
- Wyświetlenie szczegółowego stanu autoskalera dla wdrożenia `ll`

    `kubectl describe hpa ll`
    
- Uruchomienie komendy `kubectl get hpa` zwracającej listę autoskalerów w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get deploy`  

- Uruchomienie poda `load-gen` w trybie interaktywnym (opcja `-it`) po zakończeniu działania kontener zostanie usunięty (opcja `--rm`)

    `kubectl run --rm -it load-gen --image=busybox /bin/sh`

- Plik z konfiguracją wdrożenia `hpa-dep.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: php-apache
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: php-apache
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: php-apache
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      run: php-apache
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - image: k8s.gcr.io/hpa-example
        name: php-apache
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 200m
```  

- Plik z konfiguracją autoskalera `hpa.yaml`
```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: pkad
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: pkad
  minReplicas: 1
  maxReplicas: 10  
  targetCPUUtilizationPercentage: 50
```
