module com_tb ();
parameter sel=0;
parameter size=18;
parameter rsttype="sync";
reg [size-1:0] in;
reg CE,clk,RST;
wire [size-1:0] out,out2;
combine n1 (in,clk,CE, RST,out);
combine #(0,18,"async") vvvv (in,clk,CE, RST,out2);
initial begin
    clk=0;
    forever begin
    #2 clk=~clk;
end
end
initial begin
    RST=1;
CE=1;
    #7;
    RST=0;
    repeat (10)begin
    in=$random;
    @ (negedge clk);
   RST=~RST;
     end
        $stop;
end
    
endmodule