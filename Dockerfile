FROM golang:1.15.2-alpine AS builder
WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod vendor

COPY ./ci ./ci
COPY ./main.go main.go

RUN ./ci/build

FROM scratch

COPY --from=builder /app/passwall-server /app/passwall-server

COPY --from=builder /app/store /app/store

WORKDIR /app

ENV PW_DIR=/app/store

ENTRYPOINT ["/app/passwall-server"]