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