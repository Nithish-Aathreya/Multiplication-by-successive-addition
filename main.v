`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.11.2024 17:45:23
// Design Name: 
// Module Name: main
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


module main(clk,din,lda,ldp,clrp,ldb,dec,eq,bus);
input clk,lda,ldp,clrp,ldb,dec;
input [3:0]bus;
input [3:0]din;
output eq;


wire [3:0] x,y,bout,bus,sum;

assign bus = din;


acc m0(clk,lda,bus,x);
prod m1(clk,clrp,ldp,sum,y);

adder m2(x,y,sum);

secondreg m3(clk,bus,ldb,dec,bout);

comp m4(bout,eq);
endmodule

//accumulator
module acc(clk,lda,din,dout);
input [3:0]din;
input clk,lda;
output reg [3:0]dout;
always @(posedge clk)
begin
if(lda == 1'b1)
 dout<=din;
end
endmodule

//product
module prod(clk,clrp,ldp,din,dout);
input [3:0]din;
input clrp,clk,ldp;
output reg [3:0]dout;
always @(posedge clk or posedge clrp)
begin
if(clrp==1'b1)
dout<=4'b0;
else if(ldp==1'b1)
dout<=din;
end
endmodule

//adder
module adder(in1,in2,sum);
input [3:0] in1,in2;
output reg [3:0] sum;

always @(*)
begin
 sum = in1 + in2;
end

endmodule

//second register
module secondreg(clk,din,ldb,dec,dout);
input [3:0]din;
input clk,ldb,dec;
output reg [3:0]dout;
always @(posedge clk)
begin
if(ldb==1'b1)
dout<=din;
else if(dec==1'b1)
dout<=dout - 1'b1;
end
endmodule


//comparator
module comp(din,dout);
input [3:0]din;
output dout;
assign dout = (din == 4'b0000);
endmodule




module controller(clk,start,lda,clrp,ldb,ldp,dec,eq,done);
input clk,start,eq;

output reg lda,clrp,ldb,ldp,dec,done=1'b0;


reg [2:0]state;
parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100;


always @(posedge clk)
begin
case(state)
s0: if(start ==1'b1)
    state<=s1;
s1: state<=s2;
s2: state<=s3;
s3: #2 if(eq==1'b0)
        begin

    state<=s3;
    end
    else 
    begin

    state<=s4;
    end
  

s4: state<=s4;
default:state<=s0;
endcase
end

always @(state) 
begin
case(state)
 s0:begin 
 #1 lda=1'b0;ldb=1'b0;ldp=1'b0;clrp=1'b0;dec=1'b0;
 end
 s1:begin 
 #1 lda=1'b1;ldb=1'b0;ldp=1'b0;clrp=1'b1;dec=1'b0;
 end
 s2:begin 
 #1 lda=1'b0;ldb=1'b1;ldp=1'b0;clrp=1'b0;dec=1'b0;
 end
 s3:begin 
 #1 lda=1'b0;ldb=0;ldp=1'b1;clrp=1'b0;dec=1'b1;
 end
 s4:begin 
 #1 done=1'b1;lda=1'b0;ldb=1'b0;ldp=1'b0;clrp=1'b0;dec=1'b0;
 end
 default:begin 
 #1 lda=1'b0;ldb=1'b0;ldp=1'b0;clrp=1'b0;dec=1'b0;
 end
 endcase
 end
 
endmodule


