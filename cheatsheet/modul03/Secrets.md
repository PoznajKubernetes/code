# Secrets
## 03.03.03 - Demo secrets

- Utworzenie Secretu `secret-literal` typu `generic` (opcja `--from-literal`) wartości z linii poleceń `klucz=wartosc`

    `kubectl create secret generic secret-literal --from-literal=user=poznaj --from-literal=pass=kubernetets`
    
- Wypisanie Secretu `secret-literal` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get secrets secret-literal -o yaml`
    
- Dekodowanie ciągu `cG96bmFq` przy użyciu base 64

    `echo cG96bmFq | base64 -d`
    
- Utworzenie pliku `secrets.txt`  

    `echo password=TAJNE_HASLO > secrets.txt`
    
- Utworzenie Secretu `secret-file` typu `generic` (opcja `--from-file`) z pliku `secrets.txt`

    `kubectl create secret generic secret-file --from-file=secrets.txt` 
    
## 03.03.06 - Demo wykorzystanie secret w Pod

- Plik z konfiguracją poda `pod.yml` z `secret-literal`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-secret
  labels:
    name: demo-secret
spec:
  containers:
  - name: demo-secret
    image: poznajkubernetes/pkad
    envFrom:
      - secretRef:
          name: secret-literal
    resources: {}
    ports:
      - containerPort: 8080
```

- Utworzenie poda z pliku `pod.yml`

    `kubectl apply -f pod.yml`

- Mapowanie portów z kontenera do lokalnej maszyny http://localhost:8080

    `kubectl port-forward demo-secret 8080:8080`
    
- Usunięcie poda `demo-secret` z klastra

    `kubectl delete pod demo-secret`

- Plik z konfiguracją poda `pod.yml` z `secret-file` jako zmienną środowiskową
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-secret
  labels:
    name: demo-secret
spec:
  containers:
  - name: demo-secret
    image: poznajkubernetes/pkad
    envFrom:
      - secretRef:
          name: secret-file
    resources: {}
    ports:
      - containerPort: 8080
```

- Plik z konfiguracją poda `pod.yml` z `secret-file` jako wolumenem
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-secret
  labels:
    name: demo-secret
spec:
  containers:
  - name: demo-secret
    image: poznajkubernetes/pkad
    envFrom:
      - secretRef:
          name: secret-file
    volumeMounts:
      - mountPath: /secret/
        name: secret-volume
        readOnly: true
    resources: {}
    ports:
      - containerPort: 8080
  volumes:
    - name: secret-volume
      secret:
          secretName: secret-file
```

## 03.03.06 - demo prywatne repozytorium

- Logowanie do prywatnego repozytorium `poznajkubernetes.azurecr.io` obrazów Dockera

    `docker login poznajkubernetes.azurecr.io`

- Utworzenie Secretu `regcred` typu `generic` (opcja `--from-file`) z pliku `/home/poznaj/.docker/config.json` (opcja `--type`) o typie `kubernetes.io/dockerconfigjson`

    `kubectl create secret generic regcred --from-file=.dockerconfigjson=/home/poznaj/.docker/config.json --type=kubernetes.io/dockerconfigjson`
    
- Plik z konfiguracją poda `pod.yml` z obrazem w prywatnym repozytorium
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-private-registry
  labels:
    name: demo-private-registry
spec:
  containers:
  - name: demo-private-registry
    image: poznajkubernetes.azurecr.io/pkad/pkad-private:blue
    resources: {}
    ports:
      - containerPort: 8080
  imagePullSecrets:
    - name: regcred
```