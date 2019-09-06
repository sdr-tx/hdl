/* module */

module counter #(
    parameter MODULE = 50000000
)(
    input   clk,
    input   rst,
    input   enable,
    output  tc
);
    localparam WIDTH = $clog2(MODULE);

    /* Counter register */
    reg [WIDTH-1:0] count;
    reg tc2;
    assign tc=tc2;

    /* always */
    always @ (posedge clk) begin
        tc2 <= 1'b0;

        if (rst == 1'b1)
            count <=0;
        else if ( enable == 1'b1 ) begin
            count <= count + 1;
            if ( count == MODULE-1 ) begin
                count <= 0;
                tc2 <= 1'b1;
            end
        end
    end

endmodule
