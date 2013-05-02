SHELL = /bin/bash

VERSION=1.0

CC    = $(shell which gcc)
JAVAC = $(shell which javac)
JAR   = $(shell which jar)

build = build
dist  = dist

TARGETS  = $(dist)/lib/libjtux.so
TARGETS += $(dist)/lib/libjtux.so.$(VERSION)
TARGETS += $(dist)/lib/jtux.jar

OBJS =  $(build)/objs/jtux_clock.o  
OBJS += $(build)/objs/jtux_dir.o  
OBJS += $(build)/objs/jtux_file.o  
OBJS += $(build)/objs/jtux_network.o  
OBJS += $(build)/objs/jtux_posixipc.o  
OBJS += $(build)/objs/jtux_process.o  
OBJS += $(build)/objs/jtux_sysvipc.o  
OBJS += $(build)/objs/jtux_util.o

JOBJS = 

INCLUDES = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux -I./include -I./src/main/c
COPTS    = -Wimplicit -Wno-pointer-sign -Wall -D_REENTRANT -D_THREAD_SAFE -std=c99

.SUFFIXES: 

$(build)/objs/%.o: src/main/c/%.c
	$(CC) $(COPTS) $(INCLUDES) -fPIC -DLINUX -c $< -o $@

all: prep $(TARGETS)

$(build)/lib/libjtux.so: $(OBJS)
	@echo ""
	$(CC) -o $@ -shared -lrt -lnsl $^

$(build)/lib/jtux.jar: $(shell find src -type f -name '*.java')
	@echo ""
	mkdir -p $(build)/{bin,lib,classes,objs}
	$(JAVAC) -sourcepath src/main/java -d $(build)/classes $(shell find src/main/java -type f -name '*.java')
	$(JAR) cf $@ -C $(build)/classes .

clean:
	rm -rf $(build) $(dist) target

$(dist)/lib/libjtux.so: $(build)/lib/libjtux.so
	install -D --mode=644 $< $@

$(dist)/lib/libjtux.so.$(VERSION): $(build)/lib/libjtux.so
	install -D --mode=644 $< $@

$(dist)/lib/jtux.jar: $(build)/lib/jtux.jar
	install -D --mode=644 $< $@

.PHONY:prep
prep:
	@echo ""
	mkdir -p $(build)/{bin,lib,classes,objs}
	mkdir -p $(dist)/{bin,lib}
