# Używanie certyfikatów w Ingress
## 07.04.02

- Wygenerowanie certyfikatu self-sign

    `openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem`

- Utworzenie secretu z certyfikatem

    `kubectl create secret tls tls-localhost --key key.pem --cert certificate.pem`
    
- Wypisanie Secretów `tls-localhost`

    `kubectl get secrets tls-localhost`

- Plik zawierający wdrożenie, serwis i ingress `tls-demo.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pk
spec:
  selector:
    matchLabels:
      app: pk
  template:
    metadata:
      labels:
        app: pk
    spec:
      containers:
      - name: demo
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
          name: http
---
kind: Service
apiVersion: v1
metadata:
  name: pk
spec:
  selector:
    app: pk
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: http
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: pk
spec:
  tls:
  - hosts:
    - localhost
    secretName: tls-localhost
  rules:
    - host: localhost
      http:
        paths:
        - backend:
            serviceName: pk
            servicePort: 80
```

- Aplikacja z pliku `tls-demo.yaml`

    `kubectl apply -f tls-demo.yaml`
    
## 07.04.05

- Utworzenie namespace `cert-manager`

    `kubectl create namespace cert-manager`
    
- Instalacja cert-managera 

    `kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml`
    
- Polecenie wyświetla listę wszystkich obiektów w namespace (opcja `-n`) `cert-manager`
    
    `kubectl get all -n cert-manager`
    
- Plik z issuer `issuer.yaml` 
```yaml
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: lukasz@xyz.pl
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    # An empty 'selector' means that this solver matches all domains
    - selector: {}
      http01:
        ingress:
          class: nginx
```

- Plik zawierający wdrożenie, serwis i ingress`tls-demo-le.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pk
spec:
  selector:
    matchLabels:
      app: pk
  template:
    metadata:
      labels:
        app: pk
    spec:
      containers:
      - name: demo
        image: poznajkubernetes/pkad:blue
        resources: {}
        ports:
        - containerPort: 8080
          name: http
---
kind: Service
apiVersion: v1
metadata:
  name: pk
spec:
  selector:
    app: pk
  type: ClusterIP
  ports:
  - name: http
    port: 80
    targetPort: http
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: pk
  annotations:
    cert-manager.io/issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - pk-pk.52-232-21-99.nip.io
    secretName: tls-demo.52-232-21-99-nip-io
  rules:
    - host: pk-pk.52-232-21-99.nip.io
      http:
        paths:
        - backend:
            serviceName: pk
            servicePort: 80
```

- Wyświetlenie logów z poda `certmanager-598bfb5ddb-66gvx`

    `kubectl logs -n cert-manager certmanager-598bfb5ddb-66gvx`
`