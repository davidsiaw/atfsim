VERILOG_DIR=verilog
CXX_DIR=cxx

VERILOG_FILES=$(VERILOG_DIR)/macrocell.v

VERILOG_STEPS=$(patsubst verilog/%.v, obj/%.verilog_step, $(VERILOG_FILES))

CXXRTL_FILENAME=v
CXXRTL_SOURCE=$(CXXRTL_FILENAME).cpp
CXXRTL_HEADER=$(CXXRTL_FILENAME).h
CXXRTL_FILES=obj/$(CXXRTL_SOURCE) obj/$(CXXRTL_HEADER)

all: obj/$(CXXRTL_FILENAME).o

obj/%.verilog_step: verilog/%.v
	mkdir -p obj
	echo read_verilog $< > $@

obj/steps.ys: $(VERILOG_STEPS)
	cat $^ > obj/steps.ys
	echo write_cxxrtl -header $(CXXRTL_SOURCE) >> obj/steps.ys

$(CXXRTL_FILES): obj/steps.ys
	yosys obj/steps.ys
	mv $(CXXRTL_SOURCE) obj
	mv $(CXXRTL_HEADER) obj

obj/$(CXXRTL_FILENAME).o: $(CXXRTL_FILES)
	clang++ -g -std=c++14 -I `yosys-config --datdir`/include -c obj/$(CXXRTL_SOURCE) -o $@

clean:
	rm -rf obj

.PHONY: clean
