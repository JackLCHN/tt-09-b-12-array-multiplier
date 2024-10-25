/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_b_12_array_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;
  array_mult_structural inst1(ui_in[7:4], ui_in[3:0], uo_out);

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule


module array_mult_structural(
    input [3:0] m,
    input [3:0] q,
    output [7:0] p
    );
    wire hsig1, hsig2, hsig3, hsig4, hsig5, hsig6, hsig7, hsig8, hsig9;
    wire vsig1, vsig2, vsig3, vsig4, vsig5, vsig6;
    wire dsig1, dsig2;
    //layer1
    and(p[0], q[0], m[0]);
    //layer2
    fadder layer2_1(m[1]&q[0], m[0]&q[1], 1'b0, p[1], hsig1);
    fadder layer2_2(m[2]&q[0], m[1]&q[1], hsig1, vsig1, hsig2);
    fadder layer2_3(m[3]&q[0], m[2]&q[1], hsig2, vsig2, hsig3);
    fadder layer2_4(m[3]&q[1], 1'b0, hsig3, vsig3, dsig1);
    //layer3
    fadder layer3_1(m[0]&q[2], vsig1, 1'b0, p[2], hsig4);
    fadder layer3_2(m[1]&q[2], vsig2, hsig4, vsig4, hsig5);
    fadder layer3_3(m[2]&q[2], vsig3, hsig5, vsig5, hsig6);
    fadder layer3_4(m[3]&q[2], dsig1, hsig6, vsig6, dsig2);
    //layer4
    fadder layer4_1(m[0]&q[3], vsig4, 1'b0, p[3], hsig7);
    fadder layer4_2(m[1]&q[3], vsig5, hsig7, p[4], hsig8);
    fadder layer4_3(m[2]&q[3], vsig6, hsig8, p[5], hsig9);
    fadder layer4_4(m[3]&q[3], dsig2, hsig9, p[6], p[7]);
    
endmodule
module fadder(
    input x,
    input y,
    input carry_in,
    output z,
    output carry_out
);
    wire int_sig1, int_sig2, int_sig3, int_sig4, int_sig5, int_sig6, int_sig7, int_sig8;
    assign int_sig1 = x & ~y;
    assign int_sig2 = ~x & y;
    assign int_sig3 = int_sig1 | int_sig2;
    assign int_sig4 = int_sig3 & ~carry_in;
    assign int_sig5 = ~int_sig3 & carry_in;
    assign z = int_sig4 | int_sig5;
    
    assign int_sig6 = x & y;
    assign int_sig7 = y & carry_in;
    assign int_sig8 = carry_in & x;
    assign carry_out = int_sig6 | int_sig7 | int_sig8;
endmodule