build: $(wildcard *.go) go.mod go.sum
	go get ./...
	go build -o appy-backend main.go
	chmod +x appy-backend

docker: Dockerfile
	docker build -t appy-backend:1 .
