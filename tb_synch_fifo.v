`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.08.2025 09:29:08
// Design Name: 
// Module Name: tb_synch_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//`include "synchronous_fifo.v"


module tb_synch_fifo();
parameter DEPTH=16;
parameter WIDTH=8;
parameter PTR_WIDTH=4;

reg wr_en_i, rd_en_i;
reg [WIDTH-1:0] wdata_i;
wire full_o;
wire [WIDTH-1:0] rdata_o;
wire empty_o;
reg clk_i, rst_i;
wire error_o;
integer i;

synchronous_fifo dut(clk_i, rst_i, wr_en_i, rd_en_i, wdata_i, full_o, rdata_o, empty_o, error_o);

initial begin
	clk_i = 0;
	forever #5 clk_i = ~clk_i;
end

initial begin
	rst_i = 1;
	repeat(2) @(posedge clk_i);
	rst_i = 0;
	//Stimulus to the FIFO
	//make FIFO full
	for (i = 0; i < DEPTH; i=i+1) begin   //we are writing our hole fifo thats why
		@(posedge clk_i);  //given delay intension
		wdata_i = $random;
		wr_en_i = 1;  //only write when my wr_en_i==1
	end
		@(posedge clk_i);
		wdata_i = 0;
		wr_en_i = 0;
	//make FIFO empty
	for (i = 0; i < DEPTH; i=i+1) begin
		@(posedge clk_i);
		rd_en_i = 1; //we are only reading the data that allready written in our fifo thats why we dont requred $random for read daTA
	end
		@(posedge clk_i);
		rd_en_i = 0;
	#100;
	$finish;
end
endmodule