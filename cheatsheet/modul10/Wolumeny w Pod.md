# Wolumeny w Pod
## 10.02.03 - Demo - Wolumeny

- Plik z Podem `empty-dir-pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: empty-pod
  labels:
    name: empty-pod
spec:
  volumes:
  - name: empty
    emptyDir: {}
  containers:
  - name: empty-pod-bb
    image: busybox
    command: ['sh', '-c', 'echo running! && sleep 3600']
    volumeMounts:
    - name: empty
      mountPath: /pod-empty/
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: empty-pod-pkad
    image: poznajkubernetes/pkad
    volumeMounts:
    - name: empty
      mountPath: /tmp/empty-pod/
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Aplikacja poda z pliku `empty-dir-pod.yaml`

    `kubectl apply -f empty-dir-pod.yaml`

- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get pod -w`
    
- Wejście do linii poleceń (opcja `-it`) w trybie interaktywnym (opcja `-c`) w kontenerze `empty-pod-bb` w podzie `empty-pod`

    `kubectl exec empty-pod -it -c empty-pod-bb -- /bin/sh`
    
- Usunięcie (opcja `--all`) wszystkich podów z klastra

    `kubectl delete pod --all`

- Plik z Podem `host-path-pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: host-path-pod
  labels:
    name: host-path-pod
spec:
  volumes:
  - name: host-path
    hostPath:
      path: /c/poznajkubernetes/volumes/host-path
  containers:
  - name: host-path-pod-bb
    image: busybox
    command: ['sh', '-c', 'echo running! && sleep 3600']
    volumeMounts:
    - name: host-path
      mountPath: /pod-empty/
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: host-path-pod-pkad
    image: poznajkubernetes/pkad
    volumeMounts:
    - name: host-path
      mountPath: /tmp/host-path-pod/
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Polecenie wyświetla listę podów

    `kubectl get pods`

- Wykonanie polecenia `ls` (opcja `-it`) w trybie interaktywnym (opcja `-c`) w kontenerze `host-path-pod-bb` w podzie `host-path-pod`

    `kubectl exec host-path-pod -it -c host-path-pod-bb -- ls /pod-empty`
    
- Plik z ConfigMapą i Podem `sub-path-overwrite-pod.yaml`
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: subpath-overwrite-cm
data:
  appsettings.json: "our config"
  demo: "this WILL BE created"
---
apiVersion: v1
kind: Pod
metadata:
  name: subpath-overwrite-pod
  labels:
    name: subpath-overwrite-pod
spec:
  volumes:
  - name: cm
    configMap:
      name: subpath-overwrite-cm
  containers:
  - name: subpath-overwrite-pod-pkad
    image: poznajkubernetes/pkad
    volumeMounts:
    - name: cm
      mountPath: /usr/bin
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Plik z ConfigMapą i Podem `sub-path-wo-overwrite-pod.yaml`
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: subpath-wo-overwrite-cm
data:
  appsettings.json: "our config"
  demo: "this should not be created"
---
apiVersion: v1
kind: Pod
metadata:
  name: subpath-wo-overwrite-pod
  labels:
    name: subpath-wo-overwrite-pod
spec:
  volumes:
  - name: cm
    configMap:
      name: subpath-wo-overwrite-cm
  containers:
  - name: subpath-wo-overwrite-pod-pkad
    image: poznajkubernetes/pkad
    volumeMounts:
    - name: cm
      mountPath: /usr/bin/appsettings.json # only key specified here will be taken
      subPath: appsettings.json # updating by cm change does not work
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```