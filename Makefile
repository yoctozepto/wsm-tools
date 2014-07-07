default: wsm-parser
all: wsm-parser wsm-irrths

wsm-parser:
	$(MAKE) -C src wsm-parser

wsm-irrths:
	$(MAKE) -C src wsm-irrths

clean:
	$(MAKE) -C src clean
