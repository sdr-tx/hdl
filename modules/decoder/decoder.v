
module decoder (
    input   clk,
    input   rst,
    // interface with controller
    input   [7:0] data_rx,
    input   rx,
    output  reg [7:0] data_tx,
    output  reg tx,
    // interface with the modulators
    output  reg [7:0] sample,
    output  reg new_sample
);
    
    // state machine
    localparam ST_IDLE      = 0;
    localparam ST_SYNC_WORD = 1;
    localparam ST_CTRL_WORD = 2;
    localparam ST_OK        = 3;
    localparam ST_RECEIVING = 4;
    reg [2:0] state;

    reg [7:0] REG_SYNC_WORD, REG_CTRL01;

    always @(posedge clk) begin
        if (rst) begin
            data_tx <= 8'b0;
            tx <= 1'b0;
            REG_SYNC_WORD <= 8'b0;
            REG_CTRL01 <= 8'b0;
            state <= ST_IDLE;
        end
        else begin
            tx <= 1'b0;
            new_sample <= 1'b0;
            case (state)
                ST_IDLE:
                begin
                    if (rx == 1'b1 && data_rx == 8'hFF) begin
                        REG_SYNC_WORD <= data_rx;
                        state <= ST_SYNC_WORD;
                    end
                end

                ST_SYNC_WORD:
                begin
                    if (rx == 1'b1) begin
                        REG_CTRL01 <= data_rx;
                        state <= ST_CTRL_WORD;
                    end
                end

                ST_CTRL_WORD:
                begin
                    if (REG_SYNC_WORD == 8'hFF) begin
                        state <= ST_OK;                        
                    end else begin
                        state <= ST_IDLE;
                    end
                end

                ST_OK:
                begin
                    tx <= 1'b1;
                    data_tx <= REG_CTRL01;//8'h58;//8'hAA;
                    state <= ST_RECEIVING;     
                end

                ST_RECEIVING:
                begin
                    if (data_rx == 8'hFF) begin
                        state <= ST_IDLE;
                    end else if (rx == 1'b1) begin
                        new_sample <= 1'b1;
                        sample <= data_rx;
                    end
                end
            endcase
        end
    end
endmodule



