# Этап 1: сборка
FROM golang:1.23-alpine AS builder
WORKDIR /build

COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o hello-go .

# Этап 2: запуск
FROM alpine:3.20

RUN adduser -D appuser
USER appuser
WORKDIR /home/appuser

COPY --from=builder /build/hello-go ./hello-go

ENTRYPOINT ["./hello-go"]
