# Define the compiler
CC = hcc

# Define the source file
SRC = init.HC

# Define the executable name
BIN = init

# Phony targets to prevent conflicts with file names
.PHONY: all gen_commands gen_hc build clean run

# Default target (build)
all: gen_commands gen_hc build

gen_commands: gen_commands.HC
	$(CC) $< -o $@
	./gen_commands

gen_hc: gen_hc.HC
	$(CC) $< -o $@
	./gen_hc

# Build target: Compiles the main.hc file into the executable
build: $(BIN)

$(BIN): $(SRC)
	$(CC) $< -o $@

run:
	./init

# Clean target: Removes the compiled executable
clean:
	rm -f $(BIN) gen_commands commands.txt gen_hc $(SRC)
