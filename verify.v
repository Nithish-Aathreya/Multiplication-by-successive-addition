`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.11.2024 18:42:18
// Design Name: 
// Module Name: verify
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


module verify();
reg [3:0] din;
reg clk,start;
wire eq;


 wire lda, ldp, clrp, ldb, dec, done;


main dp (.clk(clk),.din(din),.lda(lda),.ldp(ldp),.clrp(clrp),.ldb(ldb),.dec(dec),.eq(eq));

controller con (.clk(clk),.start(start),.lda(lda),.clrp(clrp),.ldb(ldb),.ldp(ldp),.dec(dec),.eq(eq),.done(done));

//$monitor($time " clk=%b start=%b din=%b lda=%b ldp=%b clrp=%b ldb=%b dec=%b eq=%b done=%b",clk, start, din, lda, ldp, clrp, ldb, dec, eq, done);


initial
 begin 
 clk=1'b0;
 forever
 #5 clk = ~clk;
 end
 
initial
begin

start = 1'b0;
din=4'b0000;


 #10 start=1'b1;
 din=4'b0011;
 
 
 #20
 din=4'b0010;
 
 #20
 
 #40
 #20 
$display("completed");
 #10 $finish; 
 end
endmodule











