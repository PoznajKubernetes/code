# Persistent Volumes
## 10.03.03 - Demo - Statyczne przydzielanie PersistentVolume

- Plik z PersistentVolume `pv.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pk-pv
spec:
  storageClassName: ""
  capacity:
    storage: 100Mi
  accessModes:
  - ReadWriteOnce
  # ReadWriteMany
  # ReadOnlyMany
  # Once mounted by one of the options is not accessible
  # anymore. So having 2 options specified means that
  # only one access mode will be used and once used
  # it will not be available for mount.
  hostPath:
    path: "/c/poznajkubernetes/volumes/host-path"
```

- Plik z PersistentVolumeClaim `pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pk-sc-pvc
spec:
  storageClassName: "pk-sc"
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
```

- Plik ze wdrożeniem `deploy.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: pk-volume-svc
spec:
  selector:
    app: pk-volume-app
  type: NodePort
  ports:
  - port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pk-volume-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: pk-volume-app
  template:
    metadata:
      labels:
        app: pk-volume-app
    spec:
      volumes:
      - name: pvc-volume
        persistentVolumeClaim:
          claimName: pk-pvc
      containers:
      - name: pk-volume-app
        image: nginx
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: pvc-volume
```

- Polecenie wyświetla listę PersistentVolume (opjca `-w`) w pętli

    `kubectl get pv -w`
    
- Polecenie wyświetla listę PersistentVolumeClaim (opjca `-w`) w pętli

    `kubectl get pvc -w`
    
- Utworzenie PersistentVolume z pliku `pv.yml`

    `kubectl create -f pv.yml`

- Wyświetlenie szczegółowego stanu PersistentVolume `pk-pv`

    `kubectl describe pv pk-pv`
    
- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    
- Plik z PersistentVolume Recycle `pv.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pk-recycle-pv
spec:
  storageClassName: ""
  persistentVolumeReclaimPolicy: Recycle
  capacity:
    storage: 10Mi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: "/c/poznajkubernetes/volumes/recycle"
```

- Plik z PersistentVolumeClaim Recycle `pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pk-recycle-pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
```

- Usuwa PersistentVolumeClaim o nazwie `pk-recycle-pvc`

    `kubectl delete pvc pk-recycle-pvc`

- Plik z PersistentVolume Retain `pv.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pk-retain-pv
spec:
  storageClassName: ""
  persistentVolumeReclaimPolicy: Retain
  capacity:
    storage: 10Mi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: "/c/poznajkubernetes/volumes/retain"
```

- Plik z PersistentVolumeClaim Retain `pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pk-retain-pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
```

- Usuwa PersistentVolume o nazwie `pk-retain-pv`

    `kubectl delete pv pk-retain-pv`
    
- Plik z PersistentVolume Delete `pv.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pk-delete-pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
```

- Plik z PersistentVolumeClaim Delete `pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pk-delete-pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Mi
```

## 10.03.06 - Demo - Dynamiczne tworzenie PersistentVolume

- Polecenie wyświetla listę StorageClass

    `kubectl get sc`

- Wyświetlenie szczegółowego stanu StorageClass `hostpath`

    `kubectl describe sc hostpath`
    
- Wypisanie konfiguracji StorageClass `hostpath` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get sc hostpath -o yaml`
    
- Plik z StorageClass `sc.yaml`
```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: pk-sc
# this is a provisioner that is responsible
# for creating a PersistentVolume for our PersistentVolumeClaim
# depending on provisioner, extra properties might need to be
# set or provided
provisioner: docker.io/hostpath
reclaimPolicy: Retain
# Recycle: The StorageClass "pk-sc" is invalid: reclaimPolicy: 
# Unsupported value: "Recycle": supported values: "Delete", "Retain"
```
    
- Aplikacja StorageClass z pliku `sc.yaml`

    `kubectl apply -f sc.yaml`
    
- Uruchomienie komendy `kubectl get pv` zwracającej listę PersistentVolume w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get pv`
    
- Uruchomienie komendy `kubectl get pvc` zwracającej listę PersistentVolumeClaim w pętli (opcja `-n`) co minutę (opcja `-t`) bez tytułu

    `watch -n 1 -t kubectl get pvc`
    
- Usunięcie (opcja `--all`) wszystkich PersistentVolume i PersistentVolumeClaim z klastra

    `kubectl delete pv,pvc --all`