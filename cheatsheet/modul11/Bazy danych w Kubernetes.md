# Bazy danych w Kubernetes
## 110302

- Polecenie wyświetla listę podów (opcja `-o` ) `wide` wraz z adresem IP 

    `kubectl get pods -o wide`
    
- Wyłączenie węzła z klastra `aks-agentpool-380642257-1` (opcja `--ignore-dmonsets`) pozwala na usunięcie podów zarządzanych przez DaemonSet (opcja `--delete-local-data`) usunięcie danych lokalnych

    `kubectl drain aks-agentpool-380642257-1 --delete-local-data --ignore-dmonsets`
    
## 110305

- Instalacja mongodb przy użyciu Helm o nazwie `pk-demo` z obrazu `stable/mongodb` (opcja `-f`) z parametrami z pliku `https://raw.githubusercontent.com/helm/charts/master/stable/mongodb/values-production.yaml`

    `helm install pk-demo stable/mongodb -f https://raw.githubusercontent.com/helm/charts/master/stable/mongodb/values-production.yaml`
    
- Polecenie wyświetla listę serwisów

    `kubectl get svc`
    
- Polecenie wyświetla listę StatefulSet

    `kubectl get statefulsets.apps`
    
- Polecenie wyświetla listę PersistentVolumeClaim

    `kubectl get pvc`
    
- Polecenie wyświetla listę PersistentVolume

    `kubectl get pv`
    
- Polecenie wyświetla listę podów

    `kubectl get pod`
    
- Utworzenie poda (opcja `--namespace`) w domyślnym namespace 
                  (opcja `--image=bitnami/mongodb`) z obrazu `bitnami/mongodb` 
                  (opcja `-i`)  w trybie interaktywnym 
                  (opcja `--restart=Never`) nie restartuj gdy już istnieje 
                  (opcja `--command`) uruchomienie w nim komendy `mongo admin --host pk-demo-mongodb --autenthicationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD`
                  (opcja `--rm`) po zakończeniu działania kontener zostanie usunięty 

    `kubectl run --namespace default pk-demo-mogodb-client --rm -tty -i --restart=Never --image=bitnami/mongodb --command -- mongo admin --host pk-demo-mongodb --autenthicationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD`
    
## 110308

- Utworzenie obiektów z pliku `configmap.yml`

    `kubectl create -f manifests/configmap.yaml`
    
- Utworzenie obiektów z pliku pod adresem `https://raw.githubusercontent.com/zalando/postgres-operator/master/manifests/minimal-postgres-manifest.yaml`

    `kubectl create -f https://raw.githubusercontent.com/zalando/postgres-operator/master/manifests/minimal-postgres-manifest.yaml`
 
- Polecenie wyświetla listę obiektów typu `postgresql.acid.zalan.do`

    `kubectl get postgresql.acid.zalan.do`
    
    