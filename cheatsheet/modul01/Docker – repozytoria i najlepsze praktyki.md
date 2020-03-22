# Docker – repozytoria i najlepsze praktyki
## 01.07.02 Budowanie obrazów w Docker

- Uruchomienie aplikacji `main.go`

    `go run main.go`

- Budowa obrazu Dockera o nazwie `helloapp`

    `docker build -t helloapp .`

- Lista obrazów w Docker

    `docker images`

- Uruchomienie kontenera w trybie interaktywnym  (opcja `-it`) z mapowaniem portów do lokalnej maszyny http://localhost:8080 (opcja `-p 80:8080`) po zakończeniu działania kontener zostanie usunięty (opcja `--rm`)

    `docker run --rm -it -p 80:8080 helloapp`

- Uruchomienie kontenera w tle (opcja `-d`) z mapowaniem portów do lokalnej maszyny http://localhost:8080 (opcja `-p 80:8080`) 

    `docker run -d -p 80:8080 helloapp`

- Wyświetlenie listy uruchomionych kontenerów w Docker

    `docker ps`

- Zatrzymanie kontenera o nazwie `keen_darwin`

    `docker stop keen_darwin`

- Uruchomienie kontenera o nazwie `keen_darwin`

    `docker start keen_darwin`

- Logowanie do repozytorium obrazów Dockera

    `docker login -u username -p password`

- Nadanie taga `poznajkubernetes/helloapp:build` na podstawie istniejącego taga `helloapp:latest`

    `docker tag helloapp:latest poznajkubernetes/helloapp:build`

- Wgranie lokalnego obrazu z tagiem `poznajkubernetes/helloapp:build` do zewnętrznego repozytorium obrazów Dockera

    `docker push poznajkubernetes/helloapp:build`

- Usunięcie lokalnie przechowywanego obrazu Dockera

    `docker rmi helloapp:latest`
    `docker rmi poznajkubernetes/helloapp:build`

- Ściągnięcie obrazu z zewnętrznego repozytorium

    `docker pull poznajkubernetes/helloapp:build`


## 01.07.05 Multistage build w Docker

- Budowanie obrazu w Docker 

    `docker build -t helloapp:build .`
    
- Historia obrazu w Docker

    `docker history helloapp:build` 

- Lista obrazów w Docker

    `docker images`

- Uruchomienie kontenera w trybie interaktywnym  (opcja `-it`) z mapowaniem portów do lokalnej maszyny http://localhost:8080 (opcja `-p 80:8080`) po zakończeniu działania kontener zostanie usunięty (opcja `--rm`)

    `docker run --rm -it -p 80:8080 helloapp:multi`