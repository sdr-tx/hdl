TOP := top_level
# default modulator
MOD := am
SRC := $(filter-out $(wildcard ../modules/modulator_*/*.v), $(wildcard ../modules/**/*.v ../top/$(TOP).v) )
SRC += ../modules/modulator_$(MOD)/*.v
INC := ../inc/
BUILD = ../build

# Mercurial SDR Board
#PACKAGE = tq144:4k
# iCE40-HX8K Breakout Board
PACKAGE = ct256
DEVICE = 8k
PCF = $(TOP).pcf

all: syn pnr pack
.phony: show, prog, load-cram, clean

syn: $(BUILD)/$(TOP).json
pnr : $(BUILD)/$(TOP).asc
pack: $(BUILD)/$(TOP).bin


show:
	@echo $(SRC)

show-defines:
	@echo $(DEFINES)

show-blocks: $(SRC)
	yosys -p "read_verilog -I$(INC) ../top/$(TOP).v; show -format svg -prefix ./show"

$(BUILD)/$(TOP).blif $(BUILD)/$(TOP).json: $(SRC)
	mkdir -p $(BUILD)
	yosys -p "read_verilog $(SRC); synth_ice40 -top $(TOP) -blif $(BUILD)/$(TOP).blif -json $(BUILD)/$(TOP).json"

$(BUILD)/$(TOP).asc: $(BUILD)/$(TOP).json $(PCF)
	nextpnr-ice40 --hx8k --package $(PACKAGE) --pcf $(PCF) --json $(BUILD)/$(TOP).json --asc $(BUILD)/$(TOP).asc

$(BUILD)/$(TOP).bin: $(BUILD)/$(TOP).asc
	icepack $(BUILD)/$(TOP).asc $(BUILD)/$(TOP).bin

prog: $(BUILD)/$(TOP).bin
	@echo "Writing $(TOP).bin into the flash memory"
	iceprog $(BUILD)/$(TOP).bin

load-cram: $(BUILD)/$(TOP).bin
	@echo "Loading $(TOP).bin into the CRAM"
	iceprog -S $(BUILD)/$(TOP).bin

clean:
	rm $(BUILD)/$(TOP).bin $(BUILD)/$(TOP).asc $(BUILD)/$(TOP).blif --force
