AS=as
LD=ld
CC=gcc
LDFLAGS=-e _start --static
OBJ=prand.o
TARGET=getprand
SRC=getprand_armv8l.s

all: $(TARGET)

$(OBJ): $(SRC)
	$(AS) -o $@ $<

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(OBJ) $(TARGET)

#.PHONY: all clean
