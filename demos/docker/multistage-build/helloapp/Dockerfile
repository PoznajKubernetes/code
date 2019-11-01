FROM golang:1.13-alpine AS build

WORKDIR /src

COPY main*.go go.* ./

RUN go build -o /bin/helloapp

FROM scratch
COPY --from=build /bin/helloapp /bin/helloapp

# we do not need this but source code contains this
# information hardcoded, so its a good practice to
# show it here
EXPOSE 8080

CMD ["/bin/helloapp"]