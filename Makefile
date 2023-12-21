.DEFAULT_GOAL := fmt

.PHONY:fmt vet build

fmt:
	go fmt ./...

vet: fmt
	go vet ./...

build: vet
	go build

lint:
	tflint

test: FORCE
	go test test/basic_test.go

# test verbose
testv: FORCE
	go test -v test/basic_test.go

FORCE: ;
