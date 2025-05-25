CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -Iinclude

DEBUG_FLAGS = -g

xSDL2_CFLAGS = $(shell sdl2-config --cflags)
SDL2_LDFLAGS = $(shell sdl2-config --libs)

OBJDIR = build
SRCDIR = src
TESTDIR = test

UNITY_SRC = $(TESTDIR)/unity.c
UNITY_OBJ = $(OBJDIR)/unity.o

SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

TARGET = $(OBJDIR)/space_invaders.out

# Build rules. This is the default rule.
all: $(TARGET)
# This rule states that $(TARGET) depends on $(OBJS)
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(SDL2_LDFLAGS) 
# This is a pattern rule, meaning it applies to any .c file to generate its corresponding .o file.
# % is the pattern rules representing a generic part of a filename
# * is used in file matching patterns to represent any sequence of characters within filenames.
# $@ and $^
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) $(SDL2_CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(TESTDIR)/test_%.c
	$(CC) $(CFLAGS) $(SDL2_CFLAGS) -c $< -o $@

$(UNITY_OBJ): $(UNITY_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

debug: CFLAGS += $(DEBUG_FLAGS)
debug: clean $(TARGET)

clean:
	rm -rf $(OBJDIR)

