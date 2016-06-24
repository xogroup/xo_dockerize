test:
	scripts/test.sh
release: build push deploy
build:
	scripts/docker/bin/build.sh $(env)
push:
	scripts/docker/bin/push.sh $(env)
deploy:
	scripts/docker/bin/deploy.sh $(env) $(type)
