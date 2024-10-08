FROM golang:1.22.7-alpine AS builder
WORKDIR /app
COPY . .
RUN --mount=type=cache,target="/root/.cache/go-build" \
    go get ./... && \
    go build -o appy-backend

FROM alpine:3.18.4
WORKDIR /app
COPY --from=builder /app/appy-backend .
EXPOSE 8080
CMD ["./appy-backend"]
