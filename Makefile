.DEFAULT_GOAL := 32

env=prod

32:
	@sh ./build.sh 3.2 $(env)

all:
	sh ./build.sh 3.2 $(env)