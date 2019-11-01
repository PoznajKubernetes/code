# DO NOT USE IT IN PRODUCTION
FROM golang:latest 

# sets working dir and creates it if does not exists
WORKDIR /helloapp 

ADD . . 

RUN go build -o main . 

# we do not need this but source code contains this
# information hardcoded, so its a good practice to
# show it here
EXPOSE 8080

CMD ["/helloapp/main"]