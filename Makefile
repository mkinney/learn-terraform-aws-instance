.DEFAULT_GOAL := fmt

.PHONY:fmt vet build

fmt:
	go fmt ./...
	terraform fmt

vet: fmt
	go vet ./...

build: vet
	go build

up:
	terraform plan
	terraform apply

ping:
	ansible myhosts -m ping -i inventory.ini

installdd:
	ansible-playbook -i inventory.ini playbook.yml

lint:
	tflint
	terraform validate
	golangci-lint run
	yamllint *.yml

test: FORCE
	go test test/basic_test.go

# test verbose
testv: FORCE
	go test -v test/basic_test.go

FORCE: ;
