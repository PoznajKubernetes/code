# Pod – Podstawa Kubernetes
## 02.01.04 - Deklaratywne tworzenie Pod

- Plik z konfiguracją poda `pod.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  containers:
    - name: pkad
      image: poznajkubernetes/pkad:blue
      resources:
        requests:
          memory: "128Mi"
          cpu: "500m"
      ports:
        - containerPort: 8080
```

- Utworzenie poda z pliku `pod.yml`

    `kubectl create -f pod.yml`
    
- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get po -w`
    `kubectl get pod -w`
    
- Aktualizuję o pod z pliku `pod.yml`

    `kubectl apply -f pod.yml`
    
- Usuwa pod zdefiniowany w pliku `pod.yml`

    `kubectl delete -f pod.yml`
    
- Utworzenie poda z pliku `pod.yml` (opcja `--save-config=true`) z zapamiętaną konfiguracją

    `kubectl create -f pod.yml --save-config=true`
    
- Usuwa pod o nazwie `pkad`

    `kubectl delete pod pkad`
    
## 02.01.06 - Imperatywne tworzenie Pod

- Pomoc dla komendy run

    `kubectl help run`

- Utworzenie poda (opcja `--image=busybox`) z obrazu `busybox` (opcja `-i`)  w trybie interaktywnym (opcja `--restart=Never`) nie restartuj, gdy już istnieje 

    `kubectl run -i -t busybox --image=busybox --restart=Never`
    
- (opcja `--dry-run`) Symulacja utworzenia poda (opcja `--image=busybox`) z obrazu `busybox` (opcja `--restart=Never`) nie restartuj, gdy pod już istnieje (opcja `-o yaml`) raportuje w formacie `yaml` 

    `kubectl run busybox --image=busybox --restart=Never --dry-run -o yaml`
    
- (opcja `--dry-run`) Symulacja i zapis do pliku konfiguracji poda (opcja `--image=busybox`) z obrazu `busybox` (opcja `--restart=Never`) nie restartuj, gdy pod już istnieje (opcja `-o yaml`) raportuje w formacie `yaml` 

    `kubectl run busybox --image=busybox --restart=Never --dry-run -o yaml > pod.yaml`
