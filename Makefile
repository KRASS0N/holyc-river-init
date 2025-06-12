# Define the compiler
CC = hcc

# Define the source file
SRC = init.HC

# Define the object file (if intermediate objects were needed, but hcc often compiles directly)
# For simplicity with hcc, we'll compile directly to the executable.
# If hcc had a separate linking step, you might define OBJ as $(SRC:.hc=.o)

# Define the executable name
BIN = init

# Phony targets to prevent conflicts with file names
.PHONY: all render build clean run

# Default target (build)
all: render build

render:
	python3 render.py

# Build target: Compiles the main.hc file into the executable
build: $(BIN)

$(BIN): $(SRC)
	$(CC) $< -o $@

run:
	./init

# Clean target: Removes the compiled executable
clean:
	rm -f $(BIN)
	rm -f $(SRC)

# Note: This Makefile assumes 'main.hc' is a complete source file that 'hcc' can directly compile into an executable.
# If 'hcc' requires specific flags for compilation or linking, you would add them to the $(CC) line.
# For example: $(CC) $< -o $@ -some-flag
