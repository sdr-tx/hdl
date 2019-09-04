/* module */

module counter #(
    parameter MODULE = 50000000,
)(
    input   clk,
    input   rst,
    input   enable,
    output  tc
);
    localparam WIDTH = $clog2(MODULE);

    /* Counter register */
    reg [WIDTH-1:0] count;

    /* always */
    always @ (posedge clk) begin
        tc <= 1'b0;

        if (rst == 1'b1)
            count <= WIDTH'b0;
        else if ( enable == 1'b1 ) begin
            count <= count + 1;
            if ( count == MODULE ) begin
                count <= WIDTH'b0;
                tc <= 1'b1;
            end
        end
    end

endmodule
