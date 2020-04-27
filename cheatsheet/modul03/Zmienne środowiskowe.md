# Zmienne środowiskowe
## 03.01.02 - DEMO

- Plik z konfiguracją poda `env.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  containers:
  - name: pkad
    image: poznajkubernetes/pkad:blue
    env:
    - name: DEMO_1
      value: "Lukasz"
    - name: DEMO-2
      value: "z K8s"
    resources: {}
```

- Aplikacja poda z pliku `env.yml`

    `kubectl apply -f env.yml`
    
- Polecenie wyświetla listę podów

    `kubectl get pods`
    
- Wyświetlenie szczegółowego stanu poda `pkad`

    `kubectl describe pod pkad`
    
- Mapowanie portów z kontenera do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward pkad 8080`
    
- Usuwa pod o nazwie `pkad`

    `kubectl delete pod pkad`
    
- Plik z konfiguracją poda `args.yaml` 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  restartPolicy: Never
  containers:
  - name: busybox
    image: busybox
    command: ["echo"]
    args: ["Tu bedzie pierwsza $(GREETING), a tu druga $(NAME) zmienna"]   
    env:
    - name: GREETING
      value: "Warm greetings to"
    - name: NAME 
      value: "Kubernetes"
    resources: {}
```
  
- Plik z konfiguracją poda `pod-fields.yaml`     
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  containers:
  - name: pkad
    image: poznajkubernetes/pkad:blue
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: MY_POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: MY_POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: MY_POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: MY_POD_SERVICE_ACCOUNT
      valueFrom:
        fieldRef:
          fieldPath: spec.serviceAccountName
    resources: {}
```

- Wypisanie konfiguracji poda `pkad` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get pod pkad -o yaml`