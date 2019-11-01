FROM golang:1.13-alpine AS build

WORKDIR /src

COPY main*.go go.* ./

RUN go build -o /bin/helloapp

FROM scratch
COPY --from=build /bin/helloapp /bin/helloapp

CMD ["/bin/helloapp"]