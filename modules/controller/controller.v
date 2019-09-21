 
module controller #(
    parameter FOO = 10
)(
    input clk,
    input rst,

    // fifo simple interface
    input [7:0] rx_data_si,
    input rx_rdy_si,
    output reg rx_ack_si,

    output reg [7:0] tx_data_si,
    output reg tx_rdy_si,
    input tx_ack_si
);

    // state machine
    localparam ST_IDLE          = 0;
    localparam ST_TX            = 1;
    localparam ST_WAIT_TX       = 2;
    localparam ST_CONFIRM_READ  = 3;
    reg [1:0] state;

    // registers
    // reg [7:0] rx_data;
    reg [3:0] count;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            state <= ST_IDLE;
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            tx_data_si <= 8'd0;
            count <= 4'd0;
        end else begin
            // default values
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            case (state)
                ST_IDLE:
                begin
                    if (rx_rdy_si == 1'b1) begin
                        rx_ack_si <= 1'b1;
                        tx_data_si <= rx_data_si;
                        state <= ST_CONFIRM_READ;
                    end
                end

                ST_CONFIRM_READ:
                begin
                    // if (rx_rdy_si == 1'b0) begin
                        state <= ST_TX;
                    // end
                end                

                ST_TX:
                begin
                    count = count + 1;
                    if (count == 4'd10) begin
                        count = 4'd0;
                        if (tx_ack_si == 1'b0) begin
                            tx_rdy_si <= 1'b1;
                            state <= ST_WAIT_TX;
                        end
                    end
                end

                ST_WAIT_TX:
                begin
                    if (tx_ack_si == 1'b0) begin
                        state <= ST_IDLE;
                    end
                end

                default:  
                    state <= ST_IDLE;
            endcase
        end
    end
endmodule




