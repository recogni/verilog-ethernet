/*

Copyright (c) 2016-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * Generic IDDR module
 */
module iddr #
(
    // target ("SIM", "GENERIC", "XILINX", "ALTERA")
    parameter TARGET = "GENERIC",
    // IODDR style ("IODDR", "IODDR2")
    // Use IODDR for Virtex-4, Virtex-5, Virtex-6, 7 Series, Ultrascale
    // Use IODDR2 for Spartan-6
    parameter IODDR_STYLE = "IODDR2",
    // Width of register in bits
    parameter WIDTH = 1
)
(
    input  wire             clk,

    input  wire [WIDTH-1:0] d,

    output wire [WIDTH-1:0] q1,
    output wire [WIDTH-1:0] q2
);

/*

Provides a consistent input DDR flip flop across multiple FPGA families
              _____       _____       _____       _____       ____
    clk  ____/     \_____/     \_____/     \_____/     \_____/
         _ _____ _____ _____ _____ _____ _____ _____ _____ _____ _
    d    _X_D0__X_D1__X_D2__X_D3__X_D4__X_D5__X_D6__X_D7__X_D8__X_
         _______ ___________ ___________ ___________ ___________ _
    q1   _______X___________X____D0_____X____D2_____X____D4_____X_
         _______ ___________ ___________ ___________ ___________ _
    q2   _______X___________X____D1_____X____D3_____X____D5_____X_

*/

genvar n;

generate

if (TARGET == "XILINX") begin
    
end else if (TARGET == "ALTERA") begin

end else begin
    reg [WIDTH-1:0] d_reg_1 = {WIDTH{1'b0}};
    reg [WIDTH-1:0] d_reg_2 = {WIDTH{1'b0}};

    reg [WIDTH-1:0] q_reg_1 = {WIDTH{1'b0}};
    reg [WIDTH-1:0] q_reg_2 = {WIDTH{1'b0}};

    always @(posedge clk) begin
        d_reg_1 <= d;
    end

    always @(negedge clk) begin
        d_reg_2 <= d;
    end

    always @(posedge clk) begin
        q_reg_1 <= d_reg_1;
        q_reg_2 <= d_reg_2;
    end

    assign q1 = q_reg_1;
    assign q2 = q_reg_2;
end

endgenerate

endmodule
