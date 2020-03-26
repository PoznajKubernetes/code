# Zmienne środowiskowe
## 03.01.02 - DEMO

- 
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