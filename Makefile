VERILOG_DIR=verilog
CXX_DIR=cxx

VERILOG_FILES=$(wildcard $(VERILOG_DIR)/*.v)
COMPONENTS=$(patsubst $(VERILOG_DIR)/%.v, %, $(VERILOG_FILES))

YOSYS_SCRIPTS=$(patsubst %, obj/%.ys, $(COMPONENTS))

CXXRTL_OBJECTS=$(patsubst %, obj/%.o, $(COMPONENTS))
CXXRTL_SOURCES=$(patsubst %, obj/%.cpp, $(COMPONENTS))
CXXRTL_HEADERS=$(patsubst %, obj/%.h, $(COMPONENTS))

all: $(CXXRTL_OBJECTS)

obj/%.ys: $(VERILOG_DIR)/%.v
	mkdir -p obj
	echo read_verilog $< > $@
	echo write_cxxrtl -O6 -header $*.cpp >> $@

obj/%.cpp obj/%.h: obj/%.ys
	yosys $<
	mv $*.cpp obj
	mv $*.h obj

obj/%.o: obj/%.cpp obj/%.h
	clang++ -g -std=c++14 -I `yosys-config --datdir`/include -c $< -o $@

clean:
	rm -rf obj

.PHONY: clean
