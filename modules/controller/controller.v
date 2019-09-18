 
module controller #(
    parameter FOO = 10
)(
    input clk,
    input rst,

    // fifo simple interface
    input [7:0] rx_data_si,
    input rx_rdy_si,
    output rx_ack_si,

    output [7:0] tx_data_si,
    output tx_rdy_si,
    input tx_ack_si
);

    // state machine
    localparam ST_IDLE          = 0;
    localparam ST_TX            = 1;
    localparam ST_WAIT_TX       = 2;
    reg [1:0] state;

    // registers
    // reg [7:0] rx_data;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            state <= ST_IDLE;
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            tx_data <= 8'd0;
        end else begin
            // default values
            rx_ack_si <= 1'b0;
            tx_rdy_si <= 1'b0;
            case (state)
                ST_IDLE:
                begin
                    if (rx_rdy_si == 1'b1) begin
                        rx_ack_si <= 1'b1;
                        tx_data <= rx_data_si;
                        state <= ST_TX;
                    end
                end

                ST_TX:
                begin
                    if (tx_ack_si == 1'b0) begin
                        tx_rdy_si <= 1'b1;
                        state <= ST_WAIT_TX;
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




