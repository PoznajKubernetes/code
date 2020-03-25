# Zarządzanie zasobami – CPU i RAM
## 02.03.02 - Demo

- Plik z konfiguracją poda `resources.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  restartPolicy: Never
  containers:
  - name: pkad
    image: poznajkubernetes/pkad:blue
    resources: {}
    ports:
    - containerPort: 8080
```

- Aplikacja poda z pliku `resources.yml`

    `kubectl apply -f resources.yml`

- Polecenie wyświetla listę podów

    `kubectl get pods`
    
- Wyświetlenie szczegółowego stanu poda `pkad`

    `kubectl describe pod pkad`
    
- Plik z konfiguracją poda `resources-limits.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  restartPolicy: Never
  containers:
  - name: pkad
    image: poznajkubernetes/pkad:blue
    resources:
      requests:
        cpu: 0.1
        memory: 400Mi
      limits:
        cpu: 0.1
        memory: 400Mi
    ports:
    - containerPort: 8080
```

- Mapowanie portów z kontenera do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward pkad 8080`
