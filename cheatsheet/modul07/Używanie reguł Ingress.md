# Używanie reguł Ingress
## 07.03.04 - Demo - Ingress - Fanout

- Plik ze wdrożeniem `fanout-host.yarn`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-fanout-host-svc
spec:
  selector:
    app: helloapp-fanout-host-dep
  ports:
  - port: 80
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-fanout-host-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-fanout-host-dep
  template:
    metadata:
      labels:
        app: helloapp-fanout-host-dep
    spec:
      containers:
      - name: helloapp-fanout-host-dep
        image: poznajkubernetes/helloapp:svc
        ports:
        - containerPort: 8080
```

- Plik ze wdrożeniem `fanout-echo.yarn`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-fanout-echo-svc
spec:
  selector:
    app: helloapp-fanout-echo-dep
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-fanout-echo-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-fanout-echo-dep
  template:
    metadata:
      labels:
        app: helloapp-fanout-echo-dep
    spec:
      containers:
      - name: helloapp-fanout-echo-dep
        image: gcr.io/google_containers/echoserver:1.4
        ports:
        - containerPort: 8080
```

- Plik ze wdrożeniem `fanout.yarn`
```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: fanout-ing
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - http:
      paths:
      - path: /host/?(.*)
        backend:
          serviceName: helloapp-fanout-host-svc
          servicePort: 80
      - path: /echo/?(.*)
        backend:
          serviceName: helloapp-fanout-echo-svc
          servicePort: 8080
```

- Aplikacja wszystkich plików `yaml` z katalogu

    `kubectl apply -f .`
    
- Polecenie wyświetla listę wdrożeń 

    `kubectl get deploy`
    
- Polecenie wyświetla listę ingress 

    `kubectl get ing` 
    
- Wyświetlenie szczegółowego stanu ingress `fanout-ing` 

    `kubectl describe ing fanout-ing`
    
- Aplikacja wdrożenia z pliku `fanout.yml`

    `kubectl apply -f fanout.yml`
    
## 07.03.07 - Demo - Ingress - Name Based Virtual Hosting

- Plik zawierający ingress `nbvh.yaml`
```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: nbvh-ing
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - host: bug.127.0.0.1.nip.io
    http:
      paths:
      - backend:
          serviceName:  helloapp-nbvh-nohost-svc
          servicePort: 8080
  - host: demo.127.0.0.1.nip.io
    http:
      paths:
      - path: /host/?(.*)
        backend:
          serviceName: helloapp-nbvh-host-svc
          servicePort: 80
      - path: /echo/?(.*)
        backend:
          serviceName: helloapp-nbvh-echo-svc
          servicePort: 8080
      - backend:
          serviceName:  helloapp-nbvh-dumpster-svc
          servicePort: 8080
```

- Plik zawierający usługę i deployment `nbvh-dumpster.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-nbvh-dumpster-svc
spec:
  selector:
    app: helloapp-nbvh-dumpster-dep
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-nbvh-dumpster-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-nbvh-dumpster-dep
  template:
    metadata:
      labels:
        app: helloapp-nbvh-dumpster-dep
    spec:
      containers:
      - name: helloapp-nbvh-dumpster-dep
        image: gutek/dumpster:v1
        ports:
        - containerPort: 8080
```

- Plik zawierający wdrożenie i usługę `nbvh-echo.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-nbvh-echo-svc
spec:
  selector:
    app: helloapp-nbvh-echo-dep
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-nbvh-echo-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-nbvh-echo-dep
  template:
    metadata:
      labels:
        app: helloapp-nbvh-echo-dep
    spec:
      containers:
      - name: helloapp-nbvh-echo-dep
        image: gcr.io/google_containers/echoserver:1.4
        ports:
        - containerPort: 8080
```

- Plik zawierający wdrożenie i usługę `nbvh-host.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-nbvh-host-svc
spec:
  selector:
    app: helloapp-nbvh-host-dep
  ports:
  - port: 80
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-nbvh-host-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-nbvh-host-dep
  template:
    metadata:
      labels:
        app: helloapp-nbvh-host-dep
    spec:
      containers:
      - name: helloapp-nbvh-host-dep
        image: poznajkubernetes/helloapp:svc
        ports:
        - containerPort: 8080
```

- Plik zawierający wdrożenie i usługę `nbvh-nohost.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: helloapp-nbvh-nohost-svc
spec:
  selector:
    app: helloapp-nbvh-nohost-dep
  ports:
  - port: 8080
    targetPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloapp-nbvh-nohost-dep
spec:
  replicas: 2
  selector:
    matchLabels:
      app: helloapp-nbvh-nohost-dep
  template:
    metadata:
      labels:
        app: helloapp-nbvh-nohost-dep
    spec:
      containers:
      - name: helloapp-nbvh-nohost-dep
        image: poznajkubernetes/helloapp:multi
        ports:
        - containerPort: 8080
```

- Polecenie wyświetla listę podów

    `kubectl get pods`
    
    