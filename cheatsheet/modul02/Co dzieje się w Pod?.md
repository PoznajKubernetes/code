# Co dzieje się w Pod?
## 2.4.3 Demo get i describe

- Polecenie wyświetla listę podów (opjca `-w`) w pętli

    `kubectl get pods -w`

- Utworzenie poda z pliku `kuard.yml`

    `kubectl create -f kuard.yml`

- Plik z konfiguracją poda `kuard.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: kuard
spec:
 containers:
 - image: poznajkubernetes/kuard
   name: kuard
```

- Wyświetlenie szczegółowego stanu poda `kuard`

    `kubectl describe pod kuard`
    
- Opis stanów poda
```markdown 
PodStatus (phase):
    Pending - nie jest jeszcze utworzony
    Running - utworzony, chodzi
    Succeeded - wszystkie kontenery zakonczyly prace OK
    Failed - chociaz jeden kontenter sie wywalil
    Unknown - nie mozemy dostac statusu Pod


Conatainters State - patrz na reason:
    Waiting - nie jest jesze uruchomiony
    Running - jest uruchomiony
    Terminated - zakonczyl dzialanie


Conditions - conditions jakie spelnia Pod:
    True - spelnia
    False - nie spelnia
```

- Usunięcie (opcja `--all`) wszystkich podów z klastra

    `kubectl delete pods --all`
    
- Utworzenie poda (opcja `--image=busybox`) z obrazu `busybox` (opcja `--restart=Never`) nie restartuj, gdy już istnieje 

    `kubectl run bb --image=busybox --restart=Never`
    
## 02.04.06 - Demo dostęp do Logów

- Plik z konfiguracją poda `helloapp-8888.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: helloapp
spec:
 containers:
 - image: poznajkubernetes/helloapp:8888
   name: helloapp
 - image: poznajkubernetes/kuard
   name: kuard
```

- Plik z konfiguracją poda `kuard-err.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: kuard-err
spec:
 containers:
 - image: poznajkubernetes/kuard:err
   name: kuard-err
```

- Wyświetlenie logów z poda

    `kubectl logs kuard`

- Wyświetlenie (opcja `--tail=x`) x ostatnich linii logów z poda

    `kubectl logs kuard --tail=1` - ostatniej linii
    `kubectl logs kuard --tail=x` - x ostatnich linii

- Wyświetlenie (opcja `--since=xs`) x ostatnich sekund logów z poda

    `kubectl logs kuard --since=50s` - ostatnich 50 sekund
    
- Wyświetlenie (opcja `-c helloapp`) z kontenera `helloapp` na podzie `helloapp` - opcja wymagana, gdy w podzie jest więcej niż jeden kontener

    `kubectl logs helloapp -c helloapp`
    
## 02.04.09 - Demo wykorzystanie exec

- Plik z konfiguracją poda `helloapp-exec.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: helloapp-exec
spec:
 containers:
# THIS IS DEMO!!! CAUTION!!!
 - image: poznajkubernetes/kuard
   name: kuard
 - image: poznajkubernetes/helloapp:8888 
   name: helloapp
```

- Wykonanie polecenia `ls` w domyślnym kontenerze w podzie

    `kubectl exec helloapp-exec -- ls`
    
- Wykonanie polecenia `ls` (opcja `-c`) w kontenerze `kuard` w podzie

    `kubectl exec helloapp-exec -c kuard -- ls`
    
- Wykonanie polecenia `wget -qO- http://localhost:8080` (opcja `-c`) w kontenerze `kuard` w podzie

    `kubectl exec helloapp-exec -c kuard -- wget -qO- http://localhost:8080`

- Wejście do linii poleceń (opcja `-it`) w trybie interaktywnym (opcja `-c`) w kontenerze `kuard` w podzie

    `kubectl exec helloapp-exec -c kuard -it -- /bin/bash`

## 02.04.12 - Demo dostęp do aplikacji za pomocą port-forawrd     

- Plik z konfiguracją poda `helloapp-pf.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: helloapp-pf
spec:
 containers:
# THIS IS DEMO!!! CAUTION!!!
 - image: poznajkubernetes/kuard
   name: kuard
# Czesc, STATEK, multistage build, FROM scratch!!!!
 - image: poznajkubernetes/helloapp:8888 
   name: helloapp
```
 
- Mapowanie portu 8888 z poda do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward helloapp-pf 8080:8888`

- (opcja `--follow`) Ciągłe wyświetlanie (opcja `-c kuard`) z kontenera `kuard` na podzie `helloapp-pf` - opcja wymagana, gdy w podzie jest więcej niż jeden kontener

    `kubectl logs helloapp-pf -c kuard --follow`
    
## 02.04.15 - Demo Proxy

- Plik z konfiguracją poda `helloapp.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
 name: helloapp
spec:
 containers:
 - image: poznajkubernetes/helloapp:multi
   name: helloapp
```

- Uruchomienie proxy do API serwera

    `kubectl proxy`