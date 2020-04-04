# Etykiety – Grupowanie zasobów
## 04.01.02 - Etykiety - Demo - Etykiety

- Plik z konfiguracją poda `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  containers:
  - name: pkad
    image: poznajkubernetes/pkad
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Aplikacja poda na klaster z pliku `pkad.yaml`

    `kubectl apply -f pkad.yaml`
    
- Polecenie wyświetla listę podów

    `kubectl get pods`

- Polecenie wyświetla listę podów (opcja `--show-labels`) wyświetla nazwy etykiet

    `kubectl get pods --show-labels`
    
- Dodaje etykietę `klucz=wartość` do poda `pkad` nie nadpisuje istniejących etykiet

    `kubectl lablel pod pkad app=pkad env=test`
    
- Usunięcie etykiety o kluczu `new` dla pod `pkad`

    `kubectl label pod pkad new-`
    
- Aktualizacja etykiety `klucz=wartość` do poda `pkad`

    `kubectl lablel pod pkad --overwrite env=demo`
    
- Utworzenie poda (opcja `--image=poznajkubernetes/pkad`) z obrazu `poznajkubernetes/pkad` (opcja `--restart=Never`) nie restartuj, gdy już istnieje 

    `kubectl run pkadrun --image=poznajkubernetes/pkad --restart=Never`
    
- Dodanie (opcja `--all`) do wszystkich podów w klastrze etykiety `klucz=wartość`
    
    `kubectl lablel pod --all test=val`

- Plik z konfiguracją poda `helloapp-simple.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: helloapp-simple
  labels:
    name: helloapp-simple
spec:
  containers:
  - name: helloapp-simple
    image: poznajkubernetes/helloapp:multi
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Polecenie wyświetla listę podów (opcja `-L` lub `--label-colums`) pokazuję etykiety `env` w osobnej kolumnie

    `kubectl get pods -L env`
    `kubectl get pods --label-colums env`
    
- Polecenie wyświetla listę podów (opcja `-L` lub `--label-colums`) pokazuję etykiety `env` i `app` w osobnej kolumnie

    `kubectl get pods -L env,app`
    `kubectl get pods -L env -L app`
    
- Pobranie wszystkich podów (opcja `-l` lub `--selector`) posiadających etykietę `klucz=wartość`

    `kubectl get pods -l env=test`
    `kubectl get pods --selector env=test`
    
- Pobranie wszystkich podów (opcja `-l` lub `--selector`) posiadających etykietę należącą do zbioru wartości `klucz in (wartość1, wartość2)` (opcja `--show-labels`) wyświetla nazwy etykiet

    `kubectl get pods --show-labels --selector 'env in (test, demo)'`
    
- Pobranie wszystkich podów (opcja `-l` lub `--selector`) nieposiadających etykiety należącej do zbioru wartości `klucz in (wartość1, wartość2)` (opcja `--show-labels`) wyświetla nazwy etykiet

    `kubectl get pods --show-labels --selector 'env notin (test, demo)'`
    
- Pobranie wszystkich podów (opcja `-l` lub `--selector`) posiadających etykiety obie etykiety `klucz1=wartość1,klucz2=wartość2` (opcja `--show-labels`) wyświetla nazwy etykiet

    `kubectl get pods --show-labels -l env=test,app=demo`
    
- Plik z konfiguracją poda `helloapp-recommended-labels.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: helloapp-fullset
  labels:
    app.kubernetes.io/name: helloapp
    app.kubernetes.io/instance: helloapp-fullset # A unique name identifying the instance of an application
    app.kubernetes.io/version: "1.0.0"           # The current version of the applicatio
    app.kubernetes.io/component: ui              # The component within the architecture
    app.kubernetes.io/part-of: pkad              # The name of a higher level application this one is part of
    app.kubernetes.io/managed-by: azuredevops    # The tool being used to manage the operation of an application
spec:
  containers:
  - name: helloapp-fullset
    image: poznajkubernetes/helloapp:multi
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Pobranie wszystkich podów (opcja `-l` lub `--selector`) nieposiadających etykiety `klucz` (opcja `--show-labels`) wyświetla nazwy etykiet

    `kubectl get pods --show-labels -l !run`
    
## 04.01.05 - Etykiety - Demo - JSONPath

- Plik z konfiguracją poda `pkad.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
spec:
  terminationGracePeriodSeconds: 45
  containers:
  - name: pkad
    image: poznajkubernetes/pkad
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Plik z konfiguracją `bb.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bb
spec:
  restartPolicy: Never
  containers:
  - name: bb
    image: busybox
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080

```

- Utworzenie poda z pliku `pkad.yml`

    `kubectl create -f pkad.yml`
    
- Pobranie wszystkich podów (opcja `--field-selector`) pobranie na podstawie metadanych zwierających określoną wartość  `sciezka.metadanych=wartość` pobranie wszystkich podów w statusie `Running`

    `kubectl get pods --field-selector status.phase=Running`

- Pobranie wszystkich podów (opcja `--field-selector`) pobranie na podstawie metadanych niezwierających określonej wartości `sciezka.metadanych!=wartość` pobranie wszystkich podów w nie będących statusie `Running`

    `kubectl get pods --field-selector status.phase!=Running`

- Wyciągnięcie listy podów jako reprezentacji `yaml` 

    `kubectl get pods -o jsonpath='{@}'`
    
- Wyciągnięcie pierwszego elementu z listy podów jako reprezentacji `yaml` 

    `kubectl get pods -o jsonpath='{.items[0]}'`
    
- Wyciągnięcie nazwy pierwszego elementu z listy podów

    `kubectl get pods -o jsonpath='{.items[0].metadata.name}'`
    
- Wyciągnięcie nazwy wszystkich elementów z listy podów 

    `kubectl get pods -o jsonpath='{.items[*].metadata.name}'`
    
- Wyciągnięcie nazwy drugiego elementu z listy podów

    `kubectl get pods -o jsonpath='{.items[1].metadata.name}'`

- Wyciągnięcie nazwy wszystkich elementów z listy podów (każda nazwa w osobnej linijce)

    `kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'`
    
- Wyciągnięcie nazwy wraz z przestrzenią nazw wszystkich elementów z listy podów (każda nazwa w osobnej linijce)

    `kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{end}'`
    
- Wyciągnięcie nazwy podów spełniających warunek `@.spec.terminationGracePeriodSeconds==30` elementu z listy podów

    `kubectl get pods -o jsonpath='{.items[?(@.spec.terminationGracePeriodSeconds==30)].metadata.name}'`
    
- Pobranie wszystkich podów posortowanych po polu z metadanych `.status.phase` statusie
    `kubectl get pods --sort-by=.status.phase`

- Pobranie wszystkich podów posortowanych po polu z metadanych `.metadata.name` nazwie
    `kubectl get pods --sort-by=.metadata.name`

- Pobranie wszystkich podów posortowanych po polu z metadanych `.metadata.creationTimestamp` dacie utworzenia
    `kubectl get pods --sort-by=.metadata.creationTimestamp`

- Wypisanie konfiguracji wszystkich podów (opcja `-o yaml`) w postaci `yaml`

    `kubectl get pods -o yaml`