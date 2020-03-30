# ConfigMap
## 03.02.03 - ConfigMap - Demo - Imperatywne Tworzenie Config Map

- Utworzenie ConfigMapy (opcja `--from-literal`) wartości z linii poleceń `klucz=wartosc`

    `kubectl create configmap t1cm --from-literal=klulcz1=wartosc1 --from-literal=klucz2=wartosc2`
    `kubectl create cm t1cm --from-literal=klulcz1=wartosc1 --from-literal=klucz2=wartosc2`
    
- Polecenie wyświetla listę ConfigMap

    `kubectl get configmap`
    `kubectl get cm`
    
- Wyświetlenie szczegółowego stanu ConfigMapy `t1cm`

    `kubectl describe cm t1cm`
    
- Wypisanie ConfigMapy `t1cm` (opcja `-o yaml`) w postaci `yaml`

    `kubectl get cm t1cm -o yaml`
    
    
- Plik `toml` importowany do ConfigMap `config.toml` 
 ```toml
 # TOML... if it looks familiar, you're that old ;)
 # history loves to repeat ;)
 
 title = "TOML Example"
 
 [owner]
 name = "Tom Preston-Werner"
 dob = 1979-05-27T07:32:00-08:00 # First class dates
 
 [database]
 server = "192.168.1.1"
 ports = [ 8001, 8001, 8002 ]
 connection_max = 5000
 enabled = true
 
 [servers]
 
   # Indentation (tabs and/or spaces) is allowed but not required
   [servers.alpha]
   ip = "10.0.0.1"
   dc = "eqdc10"
 
   [servers.beta]
   ip = "10.0.0.2"
   dc = "eqdc10"
 
 [clients]
 data = [ ["gamma", "delta"], [1, 2] ]
 
 # Line breaks are OK when inside arrays
 hosts = [
   "alpha",
   "omega"
 ]
```

- Plik `json` importowany do ConfigMap `config.json` 
```json
{
  "section0": {
    "key0": "value",
    "key1": "value"
  },
  "section1": {
    "key0": "value",
    "key1": "value"
  },
  "section2": {
    "subsection0": {
      "key0": "value",
      "key1": "value"
    },
    "subsection1": {
      "key0": "value",
      "key1": "value"
    }
  }
}
```

- Utworzenie ConfigMapy (opcja `--from-literal`) wartości z linii poleceń `klucz=wartosc` i (opcja `--from-file`) wartości z pliku `config.toml`

    `kubectl create cm t3cm --from-file=config.toml --from-literal=a=b`
    
- Utworzenie ConfigMapy (opcja `--from-literal`) wartości z linii poleceń `klucz=wartosc`, (opcja `--from-file`) wartości z pliku `config.toml` i (opcja `--from-file`) wartość z pliku `config.json` umieszczona pod kluczem `some_json_config`
    
    `kubectl create cm t4cm --from-file=config.toml --from-literal=a=b --from-file=some_json_config=config.json`

## 03.02.04 i 1/2 - ConfigMap - Demo - Deklaratywne tworzenie ConfigMap

- Usunięcie (opcja `--all`) wszystkich ConfigMap z klastra

    `kubectl delete cm --all` 
    
- Plik z konfiguracją ConfigMapy `t1cm.yaml`
```yaml
apiVersion: v1
data:
  klucz1: wartosc1
  klucz2: wartosc2
kind: ConfigMap
metadata:
  name: t1cm
```

- Utworzenie ConfigMapy z pliku `t1cm.yml`

    `kubectl create -f t1cm.yaml`
    
- Edycja ConfigMapy `t1cm` w domyślnym edytorze 

    `kubectl edit cm t1cm`
    
- Plik z konfiguracją ConfigMapy `t3cm.yaml`
```yaml
apiVersion: v1
data:
  a: b
  config.toml: "# TOML... if it looks familiar, you're that old ;)\r\n# history loves
    to repeat ;)\r\n\r\ntitle = \"TOML Example\"\r\n\r\n[owner]\r\nname = \"Tom Preston-Werner\"\r\ndob
    = 1979-05-27T07:32:00-08:00 # First class dates\r\n\r\n[database]\r\nserver =
    \"192.168.1.1\"\r\nports = [ 8001, 8001, 8002 ]\r\nconnection_max = 5000\r\nenabled
    = true\r\n\r\n[servers]\r\n\r\n  # Indentation (tabs and/or spaces) is allowed
    but not required\r\n  [servers.alpha]\r\n  ip = \"10.0.0.1\"\r\n  dc = \"eqdc10\"\r\n\r\n
    \ [servers.beta]\r\n  ip = \"10.0.0.2\"\r\n  dc = \"eqdc10\"\r\n\r\n[clients]\r\ndata
    = [ [\"gamma\", \"delta\"], [1, 2] ]\r\n\r\n# Line breaks are OK when inside arrays\r\nhosts
    = [\r\n  \"alpha\",\r\n  \"omega\"\r\n]"
kind: ConfigMap
metadata:
  name: t3cm
```

- Aplikacja ConfigMapy z pliku `t3cm.yml`

    `kubectl apply -f t3cm.yaml`
    
    
# 03.02.06 - ConfigMap - Demo - Wykorzystanie Config Map jako zmiennych Środowiskowych 

- Plik z konfiguracją poda `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
  labels:
    name: pkad
spec:
  containers:
  - name: pkad
    image: poznajkubernetes/pkad
    env:
    - name: TEST
      value: Poznaj Kubernetes
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
    ports:
      - containerPort: 8080
```

- Wypisanie zmiennych środowiskowych poda `pkad`

    `kubectl exec pkad -- printenv`
    
- Mapowanie portów z kontenera do lokalnej maszyny <http://localhost:8080>

    `kubectl port-forward pkad 8080:8080`
    
- Usunięcie poda `pkad` z klastra

    `kubectl delete pod pkad`
    
## 03.02.09 - ConfigMap - Demo - Wykorzystanie Config Map jako wolumenów

- Plik z konfiguracją poda `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
  labels:
    name: pkad
spec:
  volumes:
    - name: cm-t3-v
      configMap:
        name: t3cm
        items:
          - key: config.toml
            path: awesome_ini_as_toml.toml
  containers:
    - name: pkad
      image: poznajkubernetes/pkad
      volumeMounts:
        - mountPath: /etc/config
          name: cm-t3-v
      env:
        - name: TEST
          value: Poznaj Kubernetes
      resources:
        limits:
          memory: "128Mi"
          cpu: "500m"
      ports:
        - containerPort: 8080
```

- Uruchomienie polecenia wyświetlenia zawartości katalogu `ls /etc/config` w podzie `pkad`  

    `kubectl exec pkad -- ls /etc/config`
    
- Uruchomienie polecenia wyświetlenia zawartości pliku `cat /etc/config/awesome_ini_as_toml.toml` w podzie `pkad`  

    `kubectl exec pkad -- cat /etc/config/awesome_ini_as_toml.toml`
    
- Plik z konfiguracją poda `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pkad
  labels:
    name: pkad
spec:
  volumes:
    - name: cm-t1-v
      configMap:
        name: t1cm
    - name: cm-t3-v
      configMap:
        name: t3cm
        items:
          - key: config.toml
            path: awesome_ini_as_toml.toml
  containers:
    - name: pkad
      image: poznajkubernetes/pkad
      volumeMounts:
        - name: cm-t3-v
          mountPath: /etc/configt1
        - name: cm-t3-v 
          mountPath: /etc/config
      env:
        - name: TEST
          value: Poznaj Kubernetes
      resources:
        limits:
          memory: "128Mi"
          cpu: "500m"
      ports:
        - containerPort: 8080
```