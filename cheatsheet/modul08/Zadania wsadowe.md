# Zadania wsadowe
## 08.01.02 - demo

- (opcja `--dry-run`) Symulacja utworzenia zadania wsadowego `job-demo` (opcja `--image=busybox`) z obrazu `busybox` (opcja `-o yaml`) raportuje w formacie `yaml` 
    
    `kubectl  create job job-demo --image busybox -o yaml --dry-run`

- Plik zawierający zadanie wsadowe`job-demo.yaml`
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: job-demo
spec:
  #activeDeadlineSeconds: 30
  #completions: 5
  #parallelism: 3
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - image: busybox
        name: job-demo
        resources: {}
        command:
        - /bin/sh
        - -c
        - while [[ "$(wget --server-response --spider --quiet "http://workqueue.getsandbox.com/${HOSTNAME}" 2>&1 | awk 'NR==1{print $2}')" != "200" ]]; do echo "waiting" & sleep 15; done
      restartPolicy: Never
status: {}
```

- Polecenie wyświetla listę podów

    `kubectl get po`
    
- Usunięcie zadanie wsadowego `job-demo` z klastra

    `kubectl delete jobs.batch job-demo`
    
- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get po -w`
    
- Polecenie wyświetla zadań wsadowych (opjca `-w`) w pętli

    `kubectl get jobs.batch -w`

