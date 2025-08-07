# ARMv7 32-bit Linux Assembly Random String Generator

## Overview

**prand** is a minimal user space program written in ARMv7 (32-bit ARM) assembly for Linux. It generates a secure 32 character pseudo random string sampled from a custom set of alphanumeric and symbol characters. This is done purely by invoking Linux system calls, without any C runtime or libraries, making the program extremely small and self contained.

---

## Features

- Directly uses the Linux `getrandom` system call (syscall number 384 on ARMv7) to gather 32 bytes of cryptographically secure random data.
- Transforms the raw random bytes into readable characters by mapping each byte modulo the size of a predefined character set.
- Prints the generated string followed by a newline to standard output.
- Implements its own program entry (`_start`) with no reliance on `libc` or startup files.
- Statically linked and designed to run on bare ARMv7 Linux systems or emulators.

---

## Character Set

The random string is composed from this character set of length 78:

```
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789():;!+-$#@/*={}
```


This set includes uppercase, lowercase, digits, and a selection of common symbols ensuring a broad range of output characters.

---

## Low-Level Implementation Details

### Syscall Interface

The program directly interfaces with Linux syscalls following the ARM 32-bit EABI convention:

- `r7` holds the syscall number.
- Arguments are passed in `r0`, `r1`, `r2`, etc.
- `svc #0` triggers the syscall.

For the key operations, syscalls used:

- **getrandom (384):**  
  Reads 32 random bytes into a buffer.  
  - `r0`: pointer to buffer  
  - `r1`: number of bytes to read  
  - `r2`: flags (0)  

- **write (4):**  
  Writes the generated string to stdout.  
  - `r0`: file descriptor (1 for stdout)  
  - `r1`: pointer to output buffer  
  - `r2`: buffer length (33 bytes including null terminator)  

- **exit (1):**  
  Cleanly exits the program with status code in `r0`.

### Memory Layout

- `.data` section stores the constant character set.
- `.bss` section reserves uninitialized memory:
  - `randbuf`: 32 bytes (random bytes buffer)
  - `outbuf`: 33 bytes (output string buffer, including null terminator)

### Control Flow

1. Call `getrandom` syscall to fill `randbuf` with 32 random bytes.
2. Verify if the syscall returned exactly 32 bytes, else exit with error.
3. For each byte in `randbuf`:
   - Calculate the modulo against the character set size (78) by repeated subtraction.
   - Use the remainder as index to lookup a character in the character set.
   - Store the selected character sequentially in `outbuf`.
4. Append a null terminator byte to `outbuf`.
5. Use the `write` syscall to output the full string to stdout.
6. Exit cleanly with success status.

---

## Assembly Code Structure

- `_start`: program entry point.
- Simple loops written with explicit labels (`convert_loop`, `mod_loop`) to process each byte.
- Error handling jumps to `error_exit` label, which exits with status 1.
- Uses ARM instructions like `ldr`, `mov`, `cmp`, `b`, `blt`, `sub`, `ldrb`, `strb`.

---

## Building the Project

You can build the project using the provided `Makefile`:

```
git clone https://github.com/gaidardzhiev/getprand
cd getprand
make
```

Ensure you use a assembler and linker for ARMv7 (32-bit ARM).

---

## Usage

Run the resulting executable on an ARMv7 Linux system or emulator. The program will print a single 32 character pseudo random string to stdout.

```
./getprand
```


---

## Limitations and Notes

- The modulo operation on random bytes uses repeated subtraction, which is simple but not the most efficient; this is acceptable given the small buffer size.
- There is no error output (no stderr) beyond process exit codes.
- This program assumes the ARM 32 bit Linux syscall convention and wont run on other Linux architectures without modification.

---

## License



---

