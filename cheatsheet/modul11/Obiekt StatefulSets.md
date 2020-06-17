# Obiekt StatefulSets
## 110102

- Plik z StatefulSet `ss.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkad-ss
spec:
  serviceName: pkad-ss
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

- Aplikacja StatefulSet z pliku `ss.yml`

    `kubectl apply -f ss.yml`
    
- Polecenie wyświetla listę podów

    `kubectl get pods`
    
- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get pods -w`
    
- Usuwa StatefulSet zdefiniowany w pliku `ss.yml`

    `kubectl delete -f ss.yml`
    
## 110105

- Plik z StatefulSet `ss-headless.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: pkad-ss
  labels:
    app: pkad-ss
spec:
  ports:
  - port: 80
    name: http
  clusterIP: None
  selector:
    app: pkad-ss
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkad-ss
spec:
  serviceName: pkad-ss
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
        image: poznajkubernetes/pkad:blue
        ports:
          - containerPort: 8080
            name: http
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

- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    
- Polecenie wyświetla listę podów (opcja `-o` ) `wide` wraz z adresem IP 

    `kubectl get pods -o wide`
    
- Utworzenie poda (opcja `--generator`) przy użyciu generatora `run-pod/v1` (opcja `-it`) w trybie interaktywnym (opcja `--image`) z obrazu `giantswarm/tiny-tools` który po zakończeniu działania zostanie usunięty (opcja `--rm`)

    `kubectl run -it --rm tools --generator=run-pod/v1 --image=giantswarm/tiny-tools`
    
## 110108

- Polecenie wyświetla listę StatefulSet

    `kubectl get statefulsets.apps`

- Wyskalowanie StatefulSet `helloapp-dep` (opcja `--replicas`) do 4 instancji

    `kubectl scale statefulset pkad-ss --replicas=4`

## 110111

- Wyświetlenie szczegółowego stanu poda `pkad-ss-0`

    `kubectl describe pod pkad-ss-0`

- Plik z StatefulSet `ss-ondelete.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkad-ss
spec:
  updateStrategy:
    type: OnDelete
  serviceName: pkad-ss
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

- Usuwa pod o nazwie `pkad`

    `kubectl delete pod pkad-ss-0`
    
## 110114

- Plik z StatefulSet `ss-ondelete.yaml`
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pkad-ss
spec:
  serviceName: pkad-ss
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
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

- Polecenie wyświetla listę PersistentVolumeClaim

    `kubectl get pvc`
    
- Polecenie wyświetla listę PersistentVolume

    `kubectl get pv`