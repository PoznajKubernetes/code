# DaemonSet, czyli Pod na każdym węźle
## 09.01.02

- Plik z DaemonSetem `ds.yarn`
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: pkad-ds
spec:
  selector:
    matchLabels:
      name: pkad-ds
  template:
    metadata:
      labels:
        name: pkad-ds
    spec:
      containers:
      - name: pkad-ds
        image: poznajkubernetes/pkad:blue
        resources: {}
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 20
          timeoutSeconds: 1
          periodSeconds: 10
          failureThreshold: 3
```

- Aplikacja DaemonSetu z pliku `ds.yml`

    `kubectl apply -f ds.yaml`
    
- Polecenie wyświetla listę DaemonSetów 

    `kubectl get daemonsets` 
    
- Polecenie wyświetla listę podów

    `kubectl get pods`
    
- Polecenie wyświetla listę podów (opcja `-o` ) `wide` wraz z adresem IP 

    `kubectl get pods -o wide`
    
- Wyświetlenie szczegółowego stanu DaemonSetów

    `kubectl describe daemonsets`
    
- Usunięcie DaemonSetu `pkad-ds` z klastra

    `kubectl delete daemonsets pkad-ds`
    
- Plik z DaemonSetem `ds-ondelete.yarn`    
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: pkad-ds
spec:
  updateStrategy:
    type: OnDelete
  selector:
    matchLabels:
      name: pkad-ds
  template:
    metadata:
      labels:
        name: pkad-ds
    spec:
      containers:
      - name: pkad-ds
        image: poznajkubernetes/pkad:blue
        resources: {}
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
    
- Usuwa pod o nazwie `pkad-ds-cszn5`

    `kubectl delete pod pkad-ds-cszn5`
    
- Wyświetlenie szczegółowego stanu poda `pkad-ds-kkn7q`

    `kubectl describe pod pkad-ds-kkn7q`
    
- Wypisuje historię zmian DaemonSetu `pkad-ds`

    `kubectl rollout history daemonsets pkad-ds`
    
- Wypisuje historię zmian DaemonSetu `pkad-ds`

    `kubectl rollout history daemonsets pkad-ds`
    
- Wypisuje szczegóły DaemonSetu `pkad-ds` (opcja `--revision`) wersji pierwszej

    `kubectl rollout history daemonsets pkad-ds --revision=1` 
    
- Przywrócenie rewizji 1 DaemonSetu `pkad-ds`

    `kubectl rollout undo daemonset pkad-ds --to-revision=1`