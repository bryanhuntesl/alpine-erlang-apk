setup-network:
	docker network create ci || true

setup-apk-cache: setup-network
	docker run -d --restart always --network ci --name=dl-cdn.alpinelinux.org quay.io/vektorcloud/apk-cache:latest || true

build: setup-apk-cache
	docker build --network ci --tag bryanhuntesl/alpine-erlang-builder .

run:
	docker run --network ci -ti bryanhuntesl/alpine-erlang-builder

extract: build
	docker run -v $(shell pwd):/target --network ci -ti bryanhuntesl/alpine-erlang-builder cp -pr ./packages /target/
