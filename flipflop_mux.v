module combine (in,clk,CE,RST,out);
parameter sel =0;
parameter size=18;
parameter rsttype="sync";
input [size-1:0] in;
input clk,RST,CE;
output [size-1:0] out;
reg [size-1:0] outflip,outflip1;
wire [size-1:0] outfinal;
always @ (posedge clk) begin
    if(CE) begin
    if (RST)
    outflip<=0;
    else
outflip<=in;
    end
   // else 
     //outflip<=0;
end
always @ (posedge clk,posedge RST) begin
    if (RST)
    outflip1<=0;
    else
    if (CE)
outflip1<=in;
//else outflip1<=0;
end
assign outfinal =(rsttype=="sync")? (outflip): (outflip1);
assign out= (sel==0)?in:outfinal; 
endmodule
