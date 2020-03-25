# Cykl życia pod oraz kontenery typu Init
## 02.02.05 - Demo

- Plik z konfiguracją poda `web.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
  labels:
    name: web
spec:
  containers:
  - name: web
    image: nginx
    ports:
      - containerPort: 80
```

- Aplikacja poda z pliku `pod.yml`

    `kubectl apply -f pod.yml`
    
- Mapowanie portów z kontenera `web` do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward web 8080:80`
    
- Uruchomienie linii poleceń w kontenerze  `web`

    `kubectl exec -it web bash`
    
- Plik z konfiguracją poda `web.yaml` z wolumenem typu `emptydir`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
  labels:
    name: web
spec:
  containers:
    - name: web
      image: nginx
      ports:
        - containerPort: 80
      volumeMounts:
        - name: workdir
          mountPath: /usr/share/nginx/html
  volumes:
    - name: workdir
      emptyDir: {}
```

- Usunięcie poda `web` z klastra

    `kubectl delete pod web`

- Plik z konfiguracją poda `web.yaml` z wolumenem typu `emptydir` oraz kontenerem inicjującym `install`   
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
  labels:
    name: web
spec:
  containers:
  - name: web
    image: nginx
    ports:
      - containerPort: 80
    volumeMounts:
    - name: workdir
      mountPath: /usr/share/nginx/html
  initContainers:
  - name: install
    image: busybox
    command:
    - wget
    - "-O"
    - "/work-dir/index.html"
    - https://poznajkubernetes.pl/index.html
    volumeMounts:
    - name: workdir
      mountPath: "/work-dir"
  volumes:
  - name: workdir
    emptyDir: {}
```

- Wyświetlenie szczegółowego stanu poda `web`

    `kubectl describe pod web`

- Plik z konfiguracją poda `pod-lifecycle-pending.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle
  labels:
    name: lifecycle
spec:
  restartPolicy: Never
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing.txt; sleep 30; echo $(date +%s): END >> /loap/timing.txt;']
    volumeMounts:
    - mountPath: /loap
      name: timing
    resources:
        requests:
          cpu: 4.0
          memory: 4Gi
  volumes:
  - name: timing
    hostPath:
      path: /c/temp/
```
    
- Polecenie wyświetla listę podów

    `kubectl get pods`
    
- Wypisanie konfiguracji poda `lifecycle` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get pod lifecycle -o yaml`
    
- Plik z konfiguracją poda `pod-lifecycle-no-restert-good.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle
  labels:
    name: lifecycle
spec:
  restartPolicy: Never
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): INIT >> /loap/timing.txt']
    volumeMounts:
    - mountPath: /loap
      name: timing
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing.txt; sleep 10; echo $(date +%s): END >> /loap/timing.txt;']
    volumeMounts:
    - mountPath: /loap
      name: timing
    livenessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): LIVENESS >> /loap/timing.txt']
    readinessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): READINESS >> /loap/timing.txt']
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): POST-START >> /loap/timing.txt']
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): PRE-STOP >> /loap/timing.txt']
  volumes:
  - name: timing
    hostPath:
      path: /c/temp/
``` 

- Plik z konfiguracją poda `pod-lifecycle-no-restert-bad.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle
  labels:
    name: lifecycle
spec:
  restartPolicy: Never
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): INIT >> /loap/timing.txt']
    volumeMounts:
    - mountPath: /loap
      name: timing
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing.txt; sleep 10; echo $(date +%s): END >> /loap/timing.txt; exit 1;']
    volumeMounts:
    - mountPath: /loap
      name: timing
    livenessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): LIVENESS >> /loap/timing.txt']
    readinessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): READINESS >> /loap/timing.txt']
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): POST-START >> /loap/timing.txt']
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): PRE-STOP >> /loap/timing.txt']
  volumes:
  - name: timing
    hostPath:
      path: /c/temp/
```

## 02.02.08 - Demo

- Plik z konfiguracją poda `pod-lifecycle.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle
  labels:
    name: lifecycle
spec:
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): INIT >> /loap/timing.txt']
    volumeMounts:
    - mountPath: /loap
      name: timing
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'echo $(date +%s): START >> /loap/timing.txt; sleep 30; echo $(date +%s): END >> /loap/timing.txt;']
    volumeMounts:
    - mountPath: /loap
      name: timing
    livenessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): LIVENESS >> /loap/timing.txt']
    readinessProbe:
      exec:
        command: ['sh', '-c', 'echo $(date +%s): READINESS >> /loap/timing.txt']
    lifecycle:
      postStart:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): POST-START >> /loap/timing.txt']
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): PRE-STOP >> /loap/timing.txt']
  volumes:
  - name: timing
    hostPath:
      path: /c/temp/
```

- Utworzenie pliku logu na dysku

    `touch /mnt/c/temp/timing.txt`
    
- Wypisuje na konsole zmiany w z pliku 

    `tail -f /mnt/c/temp/timing.txt`
    
## 02.02.10 - Demo

- Plik z konfiguracją poda `grace-period.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: grace-period
  labels:
    name: grace-period
spec:
  containers:
  - name: main
    image: busybox
    command: ['sh', '-c', 'while true; do echo $(date +%s): BEEP >> /loap/timing.txt; sleep 5; done;']
    volumeMounts:
    - mountPath: /loap
      name: timing
    lifecycle:
      preStop:
        exec:
          command: ['sh', '-c', 'echo $(date +%s): SIG_TERM >> /loap/timing.txt']
  volumes:
  - name: timing
    hostPath:
      path: /c/temp/
```
