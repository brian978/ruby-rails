.DEFAULT_GOAL := 32

env=prod

40:
	@sh ./build.sh 4.0 $(env)

34:
	@sh ./build.sh 3.4 $(env)

33:
	@sh ./build.sh 3.3 $(env)

32:
	@sh ./build.sh 3.2 $(env)

all:
	sh ./build.sh 4.0 $(env)
	sh ./build.sh 3.4 $(env)
	sh ./build.sh 3.3 $(env)
	sh ./build.sh 3.2 $(env)