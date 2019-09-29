/* counter with programmable module */

module module_counter #(
    parameter WIDTH = 8
)(
    input   clk,
    input   rst,
    input   enable,
    input   [WIDTH-1:0] max_count,
    output  tc
);
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
            if ( count == max_count ) begin
                count <= 0;
                tc2 <= 1'b1;
            end
        end
    end

endmodule
