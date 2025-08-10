module mux2 (a,b,out1);
parameter size=18;
parameter sel1="DIRECT";
input [size-1:0] a,b;

output reg [size-1:0] out1;
always @ (*) begin 
    if (sel1=="DIRECT")
    out1=a;
    else if (sel1=="CASCADE")
    out1=b;
    else out1=0;
end
endmodule
