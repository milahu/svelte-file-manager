.PHONY: list
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

cleanup:
	- rm -r bin
	- rm -r web-ui/node_modules
	- rm -r web-ui/public/build
	- rm -r demo-ui/node_modules
	- rm src/pupcloud

build-prepare:
	make cleanup
	mkdir bin

build-ui:
	make build-prepare
	cd web-ui && npm install && npm run build
	- rm -r src/static/*
	cp -r web-ui/public/* src/static/

build-demo-ui:
	- rm -r demo-ui/node_modules
	- rm -r demo-ui/public/build
	cd demo-ui && npm install && npm run build

build-static:
	make build-ui
	cd src; go build -a -tags netgo,osusergo -ldflags '-w -extldflags "-static"' -o ../bin/pupcloud

zbuild-static:
	make build-static
	cd bin; 7zr a -mx9 -t7z pupcloud-v0.4.2-`uname -s|tr '[:upper:]' '[:lower:]'`-`uname -m`.7z pupcloud

build:
	make build-ui
	cd src; go build -o ../bin/pupcloud

zbuild:
	make build
	cd bin; 7zr a -mx9 -t7z pupcloud-v0.4.2-`uname -s|tr '[:upper:]' '[:lower:]'`-`uname -m`.7z pupcloud

run:
	make build
	bin/pupcloud -r demo-ui/public/testFs/ --share-prefix "http://localhost:17179" \
      --share-profile John:Cena -P b133a0c0e9bee3be20163d2ad31d6248 --max-upload-size 1

run-ui:
	cd web-ui && npm install && npm run dev

run-demo-ui:
	- rm -r demo-ui/node_modules
	- rm -r demo-ui/public/build
	cd demo-ui && npm install && npm run dev

docker:
	sudo docker build --no-cache --build-arg arch=`uname -m` -t local_pupcloud:latest .

docker-publish:
	make docker
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:latest
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:v0.4.2
	sudo docker push germanorizzo/pupcloud:latest
	sudo docker push germanorizzo/pupcloud:v0.4.2
	sudo docker rmi local_pupcloud:latest
	sudo docker rmi germanorizzo/pupcloud:latest
	sudo docker rmi germanorizzo/pupcloud:v0.4.2

docker-publish-arm:
	make docker
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:latest-arm
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:v0.4.2-arm
	sudo docker push germanorizzo/pupcloud:latest-arm
	sudo docker push germanorizzo/pupcloud:v0.4.2-arm
	sudo docker rmi local_pupcloud:latest
	sudo docker rmi germanorizzo/pupcloud:latest-arm
	sudo docker rmi germanorizzo/pupcloud:v0.4.2-arm

docker-publish-arm64:
	make docker
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:latest-arm64
	sudo docker image tag local_pupcloud:latest germanorizzo/pupcloud:v0.4.2-arm64
	sudo docker push germanorizzo/pupcloud:latest-arm64
	sudo docker push germanorizzo/pupcloud:v0.4.2-arm64
	sudo docker rmi local_pupcloud:latest
	sudo docker rmi germanorizzo/pupcloud:latest-arm64
	sudo docker rmi germanorizzo/pupcloud:v0.4.2-arm64
