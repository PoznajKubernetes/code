# Zadania cykliczne
## 08.02.02 - demo

- (opcja `--dry-run`) Symulacja utworzenia zadania cyklicznego `cronjob-demo` (opcja `--image=busybox`) z obrazu `busybox` (opcja `-o yaml`) raportuje w formacie `yaml` 

    `kubectl create cronjob cronjob-demo --image busybox --schedule="test" -o yaml --dry-run`
    
- Plik zawierający zadanie cykliczne `cronjob-demo.yaml`
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  creationTimestamp: null
  name: cronjob-demo
spec:
  successfulJobsHistoryLimit: 2
  jobTemplate:
    metadata:
      creationTimestamp: null
      name: cronjob-demo
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          containers:
          - image: busybox
            name: cronjob-demo
            resources: {}
            command:
            - /bin/sh
            - -c
            - while [[ "$(wget --server-response --spider --quiet "http://workqueue.getsandbox.com/${HOSTNAME}" 2>&1 | awk 'NR==1{print $2}')" != "200" ]]; do echo "waiting" & sleep 15; done
          restartPolicy: OnFailure
  schedule: "*/1 * * * *"
status: {}
```

- Aplikacja zadania cyklicznego z pliku `cronjob-demo.yml`

    `kubectl apply -f cronjob-demo.yml`
    
- Polecenie wyświetla zadania cykliczne (opjca `-w`) w pętli

    `kubectl get cronjobs.batch -w`
    
- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get po -w`
    
- Polecenie wyświetla zadań wsadowych (opjca `-w`) w pętli

    `kubectl get jobs.batch -w`
    
- Usunięcie zadania cyklicznego `cronjob-demo` z klastra

    `kubectl delete cronjobs.batch cronjob-demo`

- Wyświetlenie logów z zadania cyklicznego `cronjob-demo-1577038`

    `kubectl logs cronjob-demo-1577038`
    

    

    
