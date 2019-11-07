 
module controller #(
    parameter FOO = 10
)(
    input clk,
    input rst,

    // fifo simple interface
    input [7:0]         rx_data_si,
    input               rx_rdy_si,
    output reg          rx_ack_si,
    output [7:0]        tx_data_si,
    output reg          tx_rdy_si,
    input               tx_ack_si,
    // communication with decoder
    input               tx,
    input [7:0]         data_tx,
    output reg          rx,
    output [7:0]        data_rx
);

    // state machine
    localparam ST_IDLE          = 0;
    localparam ST_WAIT_RX       = 1;
    localparam ST_WAIT_TX       = 2;
    reg [1:0] state;

    // registers
    // reg [7:0] rx_data;
    reg [3:0] count;

    assign data_rx = rx_data_si;
    assign tx_data_si = data_tx;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            state <= ST_IDLE;
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            rx <= 1'b0;
            count <= 4'd0;
        end else begin
            // default values
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            rx <= 1'b0;
            case (state)
                ST_IDLE:
                begin
                    if (rx_rdy_si == 1'b1) begin
                        rx_ack_si <= 1'b1;
                        state <= ST_WAIT_RX;
                    end else if (tx == 1'b1) begin
                        tx_rdy_si <= 1'b1;
                        state <= ST_WAIT_TX;
                    end
                end

                ST_WAIT_RX:
                begin
                    rx_ack_si <= 1'b1;
                    rx <= 1'b1;
                    state <= ST_IDLE;
                end                

                ST_WAIT_TX:
                begin
                    tx_rdy_si <= 1'b1;
                    if (tx_ack_si == 1'b1) begin
                        tx_rdy_si <= 1'b0;
                        state <= ST_IDLE;
                    end
                end

                default:  
                    state <= ST_IDLE;
            endcase
        end
    end
endmodule




