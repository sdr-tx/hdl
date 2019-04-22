
TOP := top_level
SRC := $(filter-out $(wildcard ../modules/test_modules/*.v), $(wildcard ../modules/**/*.v ../top/$(TOP).v) )
INC := ../inc/
BUILD     = ../build
DEFINES := $(addprefix -D, $(DEF))


# PNR OPT
#PACKAGE = tq144:4k
#DEVICE = 8k

PACKAGE = ct256
DEVICE = 8k
PCF = $(TOP).pcf

all: syn pnr pack



.phony: show, prog, load-cram, clean

syn: $(TOP).blif
pnr : $(TOP).asc
pack: $(TOP).bin


show:
	echo $(SRC)

show-defines:
	echo $(DEFINES)

show-blocks: $(SRC)
	# http://www.clifford.at/yosys/cmd_show.html
	#yosys -p "read_verilog -I$(INC) $(DEFINES) ../top/$(TOP).v; show"
	yosys -p "read_verilog -I$(INC) $(DEFINES) ../top/$(TOP).v; show -format svg -prefix ./show"

	

$(TOP).blif: $(SRC)
	mkdir -p $(BUILD)

	yosys -p "read_verilog -I$(INC) $(DEFINES) $(SRC); synth_ice40 -top $(TOP) -blif $(BUILD)/$(TOP).blif"
	#-DUSING_UART=1

$(TOP).asc: $(TOP).blif $(PCF)
	arachne-pnr -r -d $(DEVICE) -P $(PACKAGE) -p $(PCF) $(BUILD)/$(TOP).blif -o $(BUILD)/$(TOP).asc

$(TOP).bin: $(TOP).asc
	icepack $(BUILD)/$(TOP).asc $(BUILD)/$(TOP).bin

prog: $(TOP).bin
	@echo "Writing $(TOP).bin into the flash memory"
	iceprog $(BUILD)/$(TOP).bin

load-cram: $(TOP).bin
	@echo "Loading $(TOP).bin into the CRAM"
	iceprog -S $(BUILD)/$(TOP).bin

clean:
	rm $(BUILD)/$(TOP).bin $(BUILD)/$(TOP).asc $(BUILD)/$(TOP).blif --force
