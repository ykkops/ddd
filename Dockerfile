FROM golang:1.15.2-alpine AS builder
WORKDIR /app

COPY go.mod .
# COPY go.sum .
RUN go mod vendor

COPY ./ci ./ci
COPY ./main.go main.go

RUN ./ci/build

FROM scratch

COPY --from=builder /app/main /app/main

WORKDIR /app

ENTRYPOINT ["/app/main"]