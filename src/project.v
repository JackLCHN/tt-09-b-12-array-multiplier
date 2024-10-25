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


module adder(
    input a,
    input b,
    input c,
    output y,
    output z
    );
    
// Internal Signals
    wire int_sig1;
    wire int_sig2;
    wire int_sig3;
    
        
    xor(y,a,b,c);
    and(int_sig1,a,b);
    and(int_sig2,a,c);
    and(int_sig3,b,c);
    or(z,int_sig1,int_sig2,int_sig3);
     
endmodule

module part(
    input [3:0] m,
    input [2:0] y,
    input q4,
    input c,
    output [2:0] o,
    output co,
    output p);
    wire [2:0] w;
    
    adder stage0 (m[0]&c,y[0],0,p,w[0]);
    adder stage1 (m[1]&c,y[1],w[0],o[0],w[1]);
    adder stage2 (m[2]&c,y[2],w[1],o[1],w[2]);
    adder stage3 (m[3]&c,q4,w[2],o[2],co);
  
endmodule 

module array_mult_structural(
	input [3:0] m,
	input [3:0] q,
	output [7:0] p
);
    wire [2:0] o1;
    wire [2:0] o2;
    wire [2:0] o3;
    wire [2:0] o4;

    wire [3:0] c;
    part pa (m,3'b000,0,q[0],o1,c[0],p[0]);
    part pb (m,o1,c[0],q[1],o2,c[1],p[1]);
    part pc (m,o2,c[1],q[2],o3,c[2],p[2]);
    part pd (m,o3,c[2],q[3],o4,c[3],p[3]);
    assign p[4]=o4[0];
    assign p[5]=o4[1];
    assign p[6]=o4[2];
    assign p[7]=c[3];
endmodule
