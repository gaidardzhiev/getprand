AS=as
LD=ld
CC=gcc
LDFLAGS=-e _start --static
OBJ=prand.o
TARGET=getprand
SRC=getprand.s

all: $(TARGET)

$(OBJ): $(SRC)
	$(AS) -o $@ $<

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

install:
	cp $(TARGET) /usr/bin/$(TARGET)

clean:
	rm -f $(OBJ) $(TARGET)

#.PHONY: all clean
