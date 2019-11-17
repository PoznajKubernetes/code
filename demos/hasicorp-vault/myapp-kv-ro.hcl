
# For K/V v1 secrets engine

path "secret/myapp/*" {

    capabilities = ["read", "list"]

}

# For K/V v2 secrets engine

path "secret/data/myapp/*" {

    capabilities = ["read", "list"]

}

