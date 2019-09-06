`include "../../inc/project_defines.v"

module modulator #(
    parameter FOO = 10,
    parameter AM_CLKS_IN_PWM_STEPS = `AM_CLKS_IN_PWM_STEPS,
    parameter AM_PWM_STEPS = `AM_PWM_STEPS
)(
    input clk,
    input rst,
    output pwm
);
    localparam WIDTH = $clog2(FOO);

    /* registers */
    reg [WIDTH-1:0] count;
    wire tc_pwm_step, tc_pwm_symb;
    reg [AM_PWM_STEPS-1:0] shift_register;


    /******** testing signals ********/
    reg [10:0] counter_sine_10k;
    reg [63:0] sine_1k [0:100];
    /******** testing signals ********/


    // counter to generate ticks at pwm-steps frequency
    counter #(
        .MODULE  (`AM_CLKS_IN_PWM_STEPS)
    ) inst_counter_pwm_steps (
        .clk    (clk),
        .rst    (rst),
        .enable (1'b1),
        .tc     (tc_pwm_step)
    );

    // counter to generate ticks at pwm-symbols frequency
    counter #(
        .MODULE  (AM_PWM_STEPS)
    ) inst_counter_pwm_symb (
        .clk    (clk),
        .rst    (rst),
        .enable (tc_pwm_step),
        .tc     (tc_pwm_symb)
    );

    // shift register to serialize each pwm-symbol
    always @ (posedge clk) begin
        if(rst == 1'b1)begin
            shift_register <= `AM_PWM_STEPS'd0;
            counter_sine_10k <= 0;
        end
        else if (tc_pwm_symb == 1'b1) begin
            if(counter_sine_10k == 10'd1000)
                counter_sine_10k = 0;
            else begin
                counter_sine_10k <= counter_sine_10k + 1;

                if(counter_sine_10k < 10'd10)               shift_register <= sine_1k[0];
                else if(counter_sine_10k < 10'd20)          shift_register <= sine_1k[1];
                else if(counter_sine_10k < 10'd30)          shift_register <= sine_1k[2];
                else if(counter_sine_10k < 10'd40)          shift_register <= sine_1k[3];
                else if(counter_sine_10k < 10'd50)          shift_register <= sine_1k[4];
                else if(counter_sine_10k < 10'd60)          shift_register <= sine_1k[5];
                else if(counter_sine_10k < 10'd70)          shift_register <= sine_1k[6];
                else if(counter_sine_10k < 10'd80)          shift_register <= sine_1k[7];
                else if(counter_sine_10k < 10'd90)          shift_register <= sine_1k[8];
                else if(counter_sine_10k < 10'd100)         shift_register <= sine_1k[9];
                else if(counter_sine_10k < 10'd110)         shift_register <= sine_1k[10];
                else if(counter_sine_10k < 10'd120)         shift_register <= sine_1k[11];
                else if(counter_sine_10k < 10'd130)         shift_register <= sine_1k[12];
                else if(counter_sine_10k < 10'd140)         shift_register <= sine_1k[13];
                else if(counter_sine_10k < 10'd150)         shift_register <= sine_1k[14];
                else if(counter_sine_10k < 10'd160)         shift_register <= sine_1k[15];
                else if(counter_sine_10k < 10'd170)         shift_register <= sine_1k[16];
                else if(counter_sine_10k < 10'd180)         shift_register <= sine_1k[17];
                else if(counter_sine_10k < 10'd190)         shift_register <= sine_1k[18];
                else if(counter_sine_10k < 10'd200)         shift_register <= sine_1k[19];
                else if(counter_sine_10k < 10'd210)         shift_register <= sine_1k[20];
                else if(counter_sine_10k < 10'd220)         shift_register <= sine_1k[21];
                else if(counter_sine_10k < 10'd230)         shift_register <= sine_1k[22];
                else if(counter_sine_10k < 10'd240)         shift_register <= sine_1k[23];
                else if(counter_sine_10k < 10'd250)         shift_register <= sine_1k[24];
                else if(counter_sine_10k < 10'd260)         shift_register <= sine_1k[25];
                else if(counter_sine_10k < 10'd270)         shift_register <= sine_1k[26];
                else if(counter_sine_10k < 10'd280)         shift_register <= sine_1k[27];
                else if(counter_sine_10k < 10'd290)         shift_register <= sine_1k[28];
                else if(counter_sine_10k < 10'd300)         shift_register <= sine_1k[29];
                else if(counter_sine_10k < 10'd310)         shift_register <= sine_1k[30];
                else if(counter_sine_10k < 10'd320)         shift_register <= sine_1k[31];
                else if(counter_sine_10k < 10'd330)         shift_register <= sine_1k[32];
                else if(counter_sine_10k < 10'd340)         shift_register <= sine_1k[33];
                else if(counter_sine_10k < 10'd350)         shift_register <= sine_1k[34];
                else if(counter_sine_10k < 10'd360)         shift_register <= sine_1k[35];
                else if(counter_sine_10k < 10'd370)         shift_register <= sine_1k[36];
                else if(counter_sine_10k < 10'd380)         shift_register <= sine_1k[37];
                else if(counter_sine_10k < 10'd390)         shift_register <= sine_1k[38];
                else if(counter_sine_10k < 10'd400)         shift_register <= sine_1k[39];
                else if(counter_sine_10k < 10'd410)         shift_register <= sine_1k[40];
                else if(counter_sine_10k < 10'd420)         shift_register <= sine_1k[41];
                else if(counter_sine_10k < 10'd430)         shift_register <= sine_1k[42];
                else if(counter_sine_10k < 10'd440)         shift_register <= sine_1k[43];
                else if(counter_sine_10k < 10'd450)         shift_register <= sine_1k[44];
                else if(counter_sine_10k < 10'd460)         shift_register <= sine_1k[45];
                else if(counter_sine_10k < 10'd470)         shift_register <= sine_1k[46];
                else if(counter_sine_10k < 10'd480)         shift_register <= sine_1k[47];
                else if(counter_sine_10k < 10'd490)         shift_register <= sine_1k[48];
                else if(counter_sine_10k < 10'd500)         shift_register <= sine_1k[49];
                else if(counter_sine_10k < 10'd510)         shift_register <= sine_1k[50];
                else if(counter_sine_10k < 10'd520)         shift_register <= sine_1k[51];
                else if(counter_sine_10k < 10'd530)         shift_register <= sine_1k[52];
                else if(counter_sine_10k < 10'd540)         shift_register <= sine_1k[53];
                else if(counter_sine_10k < 10'd550)         shift_register <= sine_1k[54];
                else if(counter_sine_10k < 10'd560)         shift_register <= sine_1k[55];
                else if(counter_sine_10k < 10'd570)         shift_register <= sine_1k[56];
                else if(counter_sine_10k < 10'd580)         shift_register <= sine_1k[57];
                else if(counter_sine_10k < 10'd590)         shift_register <= sine_1k[58];
                else if(counter_sine_10k < 10'd600)         shift_register <= sine_1k[59];
                else if(counter_sine_10k < 10'd610)         shift_register <= sine_1k[60];
                else if(counter_sine_10k < 10'd620)         shift_register <= sine_1k[61];
                else if(counter_sine_10k < 10'd630)         shift_register <= sine_1k[62];
                else if(counter_sine_10k < 10'd640)         shift_register <= sine_1k[63];
                else if(counter_sine_10k < 10'd650)         shift_register <= sine_1k[64];
                else if(counter_sine_10k < 10'd660)         shift_register <= sine_1k[65];
                else if(counter_sine_10k < 10'd670)         shift_register <= sine_1k[66];
                else if(counter_sine_10k < 10'd680)         shift_register <= sine_1k[67];
                else if(counter_sine_10k < 10'd690)         shift_register <= sine_1k[68];
                else if(counter_sine_10k < 10'd700)         shift_register <= sine_1k[69];
                else if(counter_sine_10k < 10'd710)         shift_register <= sine_1k[70];
                else if(counter_sine_10k < 10'd720)         shift_register <= sine_1k[71];
                else if(counter_sine_10k < 10'd730)         shift_register <= sine_1k[72];
                else if(counter_sine_10k < 10'd740)         shift_register <= sine_1k[73];
                else if(counter_sine_10k < 10'd750)         shift_register <= sine_1k[74];
                else if(counter_sine_10k < 10'd760)         shift_register <= sine_1k[75];
                else if(counter_sine_10k < 10'd770)         shift_register <= sine_1k[76];
                else if(counter_sine_10k < 10'd780)         shift_register <= sine_1k[77];
                else if(counter_sine_10k < 10'd790)         shift_register <= sine_1k[78];
                else if(counter_sine_10k < 10'd800)         shift_register <= sine_1k[79];
                else if(counter_sine_10k < 10'd810)         shift_register <= sine_1k[80];
                else if(counter_sine_10k < 10'd820)         shift_register <= sine_1k[81];
                else if(counter_sine_10k < 10'd830)         shift_register <= sine_1k[82];
                else if(counter_sine_10k < 10'd840)         shift_register <= sine_1k[83];
                else if(counter_sine_10k < 10'd850)         shift_register <= sine_1k[84];
                else if(counter_sine_10k < 10'd860)         shift_register <= sine_1k[85];
                else if(counter_sine_10k < 10'd870)         shift_register <= sine_1k[86];
                else if(counter_sine_10k < 10'd880)         shift_register <= sine_1k[87];
                else if(counter_sine_10k < 10'd890)         shift_register <= sine_1k[88];
                else if(counter_sine_10k < 10'd900)         shift_register <= sine_1k[89];
                else if(counter_sine_10k < 10'd910)         shift_register <= sine_1k[90];
                else if(counter_sine_10k < 10'd920)         shift_register <= sine_1k[91];
                else if(counter_sine_10k < 10'd930)         shift_register <= sine_1k[92];
                else if(counter_sine_10k < 10'd940)         shift_register <= sine_1k[93];
                else if(counter_sine_10k < 10'd950)         shift_register <= sine_1k[94];
                else if(counter_sine_10k < 10'd960)         shift_register <= sine_1k[95];
                else if(counter_sine_10k < 10'd970)         shift_register <= sine_1k[96];
                else if(counter_sine_10k < 10'd980)         shift_register <= sine_1k[97];
                else if(counter_sine_10k < 10'd990)         shift_register <= sine_1k[98];
                else if(counter_sine_10k < 10'd1000)        shift_register <= sine_1k[99];
            end
        end else if (tc_pwm_step == 1'b1)
            shift_register <= {shift_register[AM_PWM_STEPS-2:0],shift_register[AM_PWM_STEPS-1]};
    end

    // output assignment
    assign pwm = shift_register[AM_PWM_STEPS-1];

    always @(*) begin
        sine_1k[0] <= 64'b1111111111111111111111111111111100000000000000000000000000000000;
        sine_1k[1] <= 64'b1111111111111111111111111111111110000000000000000000000000000000;
        sine_1k[2] <= 64'b1111111111111111111111111111111111100000000000000000000000000000;
        sine_1k[3] <= 64'b1111111111111111111111111111111111111000000000000000000000000000;
        sine_1k[4] <= 64'b1111111111111111111111111111111111111110000000000000000000000000;
        sine_1k[5] <= 64'b1111111111111111111111111111111111111111100000000000000000000000;
        sine_1k[6] <= 64'b1111111111111111111111111111111111111111111000000000000000000000;
        sine_1k[7] <= 64'b1111111111111111111111111111111111111111111110000000000000000000;
        sine_1k[8] <= 64'b1111111111111111111111111111111111111111111111100000000000000000;
        sine_1k[9] <= 64'b1111111111111111111111111111111111111111111111110000000000000000;
        sine_1k[10] <= 64'b1111111111111111111111111111111111111111111111111100000000000000;
        sine_1k[11] <= 64'b1111111111111111111111111111111111111111111111111111000000000000;
        sine_1k[12] <= 64'b1111111111111111111111111111111111111111111111111111100000000000;
        sine_1k[13] <= 64'b1111111111111111111111111111111111111111111111111111110000000000;
        sine_1k[14] <= 64'b1111111111111111111111111111111111111111111111111111111100000000;
        sine_1k[15] <= 64'b1111111111111111111111111111111111111111111111111111111110000000;
        sine_1k[16] <= 64'b1111111111111111111111111111111111111111111111111111111111000000;
        sine_1k[17] <= 64'b1111111111111111111111111111111111111111111111111111111111100000;
        sine_1k[18] <= 64'b1111111111111111111111111111111111111111111111111111111111110000;
        sine_1k[19] <= 64'b1111111111111111111111111111111111111111111111111111111111111000;
        sine_1k[20] <= 64'b1111111111111111111111111111111111111111111111111111111111111000;
        sine_1k[21] <= 64'b1111111111111111111111111111111111111111111111111111111111111100;
        sine_1k[22] <= 64'b1111111111111111111111111111111111111111111111111111111111111100;
        sine_1k[23] <= 64'b1111111111111111111111111111111111111111111111111111111111111110;
        sine_1k[24] <= 64'b1111111111111111111111111111111111111111111111111111111111111110;
        sine_1k[25] <= 64'b1111111111111111111111111111111111111111111111111111111111111110;
        sine_1k[26] <= 64'b1111111111111111111111111111111111111111111111111111111111111110;
        sine_1k[27] <= 64'b1111111111111111111111111111111111111111111111111111111111111110;
        sine_1k[28] <= 64'b1111111111111111111111111111111111111111111111111111111111111100;
        sine_1k[29] <= 64'b1111111111111111111111111111111111111111111111111111111111111100;
        sine_1k[30] <= 64'b1111111111111111111111111111111111111111111111111111111111111000;
        sine_1k[31] <= 64'b1111111111111111111111111111111111111111111111111111111111111000;
        sine_1k[32] <= 64'b1111111111111111111111111111111111111111111111111111111111110000;
        sine_1k[33] <= 64'b1111111111111111111111111111111111111111111111111111111111100000;
        sine_1k[34] <= 64'b1111111111111111111111111111111111111111111111111111111111000000;
        sine_1k[35] <= 64'b1111111111111111111111111111111111111111111111111111111110000000;
        sine_1k[36] <= 64'b1111111111111111111111111111111111111111111111111111111100000000;
        sine_1k[37] <= 64'b1111111111111111111111111111111111111111111111111111110000000000;
        sine_1k[38] <= 64'b1111111111111111111111111111111111111111111111111111100000000000;
        sine_1k[39] <= 64'b1111111111111111111111111111111111111111111111111111000000000000;
        sine_1k[40] <= 64'b1111111111111111111111111111111111111111111111111100000000000000;
        sine_1k[41] <= 64'b1111111111111111111111111111111111111111111111110000000000000000;
        sine_1k[42] <= 64'b1111111111111111111111111111111111111111111111100000000000000000;
        sine_1k[43] <= 64'b1111111111111111111111111111111111111111111110000000000000000000;
        sine_1k[44] <= 64'b1111111111111111111111111111111111111111111000000000000000000000;
        sine_1k[45] <= 64'b1111111111111111111111111111111111111111100000000000000000000000;
        sine_1k[46] <= 64'b1111111111111111111111111111111111111110000000000000000000000000;
        sine_1k[47] <= 64'b1111111111111111111111111111111111111000000000000000000000000000;
        sine_1k[48] <= 64'b1111111111111111111111111111111111100000000000000000000000000000;
        sine_1k[49] <= 64'b1111111111111111111111111111111110000000000000000000000000000000;
        sine_1k[50] <= 64'b1111111111111111111111111111111000000000000000000000000000000000;
        sine_1k[51] <= 64'b1111111111111111111111111111110000000000000000000000000000000000;
        sine_1k[52] <= 64'b1111111111111111111111111111000000000000000000000000000000000000;
        sine_1k[53] <= 64'b1111111111111111111111111100000000000000000000000000000000000000;
        sine_1k[54] <= 64'b1111111111111111111111110000000000000000000000000000000000000000;
        sine_1k[55] <= 64'b1111111111111111111111000000000000000000000000000000000000000000;
        sine_1k[56] <= 64'b1111111111111111111100000000000000000000000000000000000000000000;
        sine_1k[57] <= 64'b1111111111111111110000000000000000000000000000000000000000000000;
        sine_1k[58] <= 64'b1111111111111111000000000000000000000000000000000000000000000000;
        sine_1k[59] <= 64'b1111111111111110000000000000000000000000000000000000000000000000;
        sine_1k[60] <= 64'b1111111111111000000000000000000000000000000000000000000000000000;
        sine_1k[61] <= 64'b1111111111100000000000000000000000000000000000000000000000000000;
        sine_1k[62] <= 64'b1111111111000000000000000000000000000000000000000000000000000000;
        sine_1k[63] <= 64'b1111111110000000000000000000000000000000000000000000000000000000;
        sine_1k[64] <= 64'b1111111000000000000000000000000000000000000000000000000000000000;
        sine_1k[65] <= 64'b1111110000000000000000000000000000000000000000000000000000000000;
        sine_1k[66] <= 64'b1111100000000000000000000000000000000000000000000000000000000000;
        sine_1k[67] <= 64'b1111000000000000000000000000000000000000000000000000000000000000;
        sine_1k[68] <= 64'b1110000000000000000000000000000000000000000000000000000000000000;
        sine_1k[69] <= 64'b1100000000000000000000000000000000000000000000000000000000000000;
        sine_1k[70] <= 64'b1100000000000000000000000000000000000000000000000000000000000000;
        sine_1k[71] <= 64'b1000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[72] <= 64'b1000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[73] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[74] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[75] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[76] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[77] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[78] <= 64'b1000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[79] <= 64'b1000000000000000000000000000000000000000000000000000000000000000;
        sine_1k[80] <= 64'b1100000000000000000000000000000000000000000000000000000000000000;
        sine_1k[81] <= 64'b1100000000000000000000000000000000000000000000000000000000000000;
        sine_1k[82] <= 64'b1110000000000000000000000000000000000000000000000000000000000000;
        sine_1k[83] <= 64'b1111000000000000000000000000000000000000000000000000000000000000;
        sine_1k[84] <= 64'b1111100000000000000000000000000000000000000000000000000000000000;
        sine_1k[85] <= 64'b1111110000000000000000000000000000000000000000000000000000000000;
        sine_1k[86] <= 64'b1111111000000000000000000000000000000000000000000000000000000000;
        sine_1k[87] <= 64'b1111111110000000000000000000000000000000000000000000000000000000;
        sine_1k[88] <= 64'b1111111111000000000000000000000000000000000000000000000000000000;
        sine_1k[89] <= 64'b1111111111100000000000000000000000000000000000000000000000000000;
        sine_1k[90] <= 64'b1111111111111000000000000000000000000000000000000000000000000000;
        sine_1k[91] <= 64'b1111111111111110000000000000000000000000000000000000000000000000;
        sine_1k[92] <= 64'b1111111111111111000000000000000000000000000000000000000000000000;
        sine_1k[93] <= 64'b1111111111111111110000000000000000000000000000000000000000000000;
        sine_1k[94] <= 64'b1111111111111111111100000000000000000000000000000000000000000000;
        sine_1k[95] <= 64'b1111111111111111111111000000000000000000000000000000000000000000;
        sine_1k[96] <= 64'b1111111111111111111111110000000000000000000000000000000000000000;
        sine_1k[97] <= 64'b1111111111111111111111111100000000000000000000000000000000000000;
        sine_1k[98] <= 64'b1111111111111111111111111111000000000000000000000000000000000000;
        sine_1k[99] <= 64'b1111111111111111111111111111110000000000000000000000000000000000;
    end

endmodule


