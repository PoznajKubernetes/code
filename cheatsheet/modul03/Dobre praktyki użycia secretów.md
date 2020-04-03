# Dobre praktyki użycia secretów
## 03.04.03 - DEMO Azure Key Vault

- Instalacja `Key Vault FlexVolume` na klastrze

 `kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yam`
 
- Weryfikacja instalacji - wyświetlenie listy podów (opcja `-n`) w przestrzeni nazw `kv` 

    `kubectl get pods -n kv`
    
- Utworzenie Azure AD Service Principal `pk-sp-demo` (opcja `--skip-assignment`) bez nadawania uprawnień

    `az ad sp create-for-rbac --name pk-sp-demo --skip-assignment`

- Utworzenie Secretu z Service Principal o nazwie `kvcreds`
 
    `kubectl create secret generic kvcreds --from-literal clientid=<CLIENTID> --from-literal clientsecret=<CLIENTSECRET> --type=azure/kv`
    
- Plik z Pod `nginix-flex-kv.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-flex-kv
spec:
  containers:
  - name: nginx-flex-kv
    resources: {}
    image: nginx
    volumeMounts:
    - name: test
      mountPath: /kvmnt
      readOnly: true
  volumes:
  - name: test
    flexVolume:
      driver: "azure/kv"
      secretRef:
        name: kvcreds                             # [OPTIONAL] not required if using Pod Identity
      options:
        keyvaultname: "pk-demo"              # [REQUIRED] the name of the KeyVault
        keyvaultobjectnames: "pk;demo"         # [REQUIRED] list of KeyVault object names (semi-colon separated)
        keyvaultobjecttypes: "secret;secret"               # [REQUIRED] list of KeyVault object types: secret, key, cert (semi-colon separated)
        tenantid: "<tenantid>"                    # [REQUIRED] the tenant ID of the KeyVault
```

- Uruchomienie linii poleceń w kontenerze `nginix-flex-kv`

    `kubectl exec -it nginix-flex-kv bash`
    
- Aplikacja poda z pliku `nginix-flex-kv.yml`

    `kubectl apply -f nginix-flex-kv.yml`

- Polecenie wyświetla listę podów

    `kubectl get pods`