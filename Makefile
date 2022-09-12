VERILOG_DIR=verilog
TEST_DIR=tests
CXX_DIR=cxx

VERILOG_FILES=$(wildcard $(VERILOG_DIR)/*.v)
TEST_FILES=$(wildcard $(TEST_DIR)/*.test)

COMPONENTS=$(patsubst $(VERILOG_DIR)/%.v, %, $(VERILOG_FILES))
TESTS=$(patsubst $(TEST_DIR)/%.test, %, $(TEST_FILES))

YOSYS_SCRIPTS=$(patsubst %, obj/%.ys, $(COMPONENTS))

CXXRTL_OBJECTS=$(patsubst %, obj/%.o, $(COMPONENTS))
CXXRTL_SOURCES=$(patsubst %, obj/%.cpp, $(COMPONENTS))
CXXRTL_HEADERS=$(patsubst %, obj/%.h, $(COMPONENTS))

TEST_EXECUTABLES=$(patsubst %, obj/test_%, $(TESTS))
TEST_RESULTS=$(patsubst %, obj/testresult_%, $(TESTS))

all: $(CXXRTL_OBJECTS) $(TEST_EXECUTABLES)

obj/%.ys: $(VERILOG_DIR)/%.v
	mkdir -p obj
	echo read_verilog $< > $@
	echo write_cxxrtl -O6 -header $*.cpp >> $@

obj/test_%.cpp obj/test_%.subject: tests/%.test
	bin/gentest $< > $@
	bin/gentest $< s > obj/test_$*.subject

obj/test_%: obj/test_%.cpp obj/test_%.subject
	clang++ -g -std=c++14 -I `yosys-config --datdir`/include obj/`cat obj/test_$*.subject`.o $< -o $@

obj/%.cpp obj/%.h: obj/%.ys
	yosys $<
	mv $*.cpp obj
	mv $*.h obj

obj/%.o: obj/%.cpp obj/%.h
	clang++ -g -std=c++14 -I `yosys-config --datdir`/include -c $< -o $@

obj/testresult_%: obj/test_%
	@echo [TEST] $<
	@$< > $@ || (echo "$< failed $$?"; exit 1)

test: $(TEST_RESULTS)

clean:
	rm -rf obj

cleantests:
	rm -r obj/testresult_*

.PHONY: clean test cleantests
.PRECIOUS: obj/test_%.cpp
