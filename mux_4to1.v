module mux4 (a,b,c,d,sel2,out2);
parameter size=48;
input [size-1:0] a,b,c,d;
input [1:0] sel2;
output reg [size-1:0] out2;
always @ (*) begin
    case(sel2)
    0:out2=a;
    1:out2=b;
    2:out2=c; 
    default:out2=d;
    endcase 
end
    
endmodule