FROM golang:latest 

# sets working dir and creates it if does not exists
WORKDIR /helloapp 

ADD . . 

RUN go build -o main . 

CMD ["/helloapp/main"]