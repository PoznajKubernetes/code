# Eventy oraz rozszerzenie reconciliation loop
## 02.06.02 - Demo

- Pokazuje wszystkie eventy w aktualnym namespace

    `kubectl get events`
    
- Pokazuje wszystkie eventy (opcja `--field-selector involvedObject.name=pkad`) wyszukiwnie po nazwie obiektu i (opcja `--sort-by='.metadata.creationTimestamp'`) sortowane po dacie utworzenia

    `kubectl get events --field-selector involvedObject.name=pkad --sort-by='.metadata.creationTimestamp'`
    
- Plik z konfiguracją poda `resources-limit.yaml` 
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

- Aplikacja poda z pliku `resources-limit.yml`

    `kubectl apply -f resources-limit.yml`
    
- Wyświetlenie szczegółowego stanu poda `pkad`

    `kubectl describe pod pkad`
    
- Mapowanie portów z kontenera do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward pkad 8080`