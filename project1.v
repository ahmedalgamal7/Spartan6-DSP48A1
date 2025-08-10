module DSP (A,B,D,C,clk,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,
CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
parameter A0REG=0;
parameter A1REG=1;
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1;
parameter CARRYINREG=1;
parameter CARRYOUTREG=1;
parameter OPMODEREG=1;
parameter CARRYINSEL="OPMODE5";
parameter B_INPUT="DIRECT";
parameter rsttype="sync";
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
input clk,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
output [17:0] BCOUT;
output [47:0] PCOUT,P;
output [35:0] M;
output CARRYOUT,CARRYOUTF;
wire [17:0] d_out,b0_out,a0_out,pre_out,b1_out,a1_out;
wire [17:0] b_before,pre_op;
wire [47:0] c_out;
wire [47:0] X_;
wire [35:0] mult_out;
wire [35:0] m_out;
wire [47:0] M_OUT;
wire [47:0] x_out,z_out;
wire cyi_out;
reg cascade_out;
reg [1:0] flag;
wire [47:0]post_out,post_out1,post_out2;
wire [7:0] OPMODE_OUT;
wire cout,cout1,cout2;


combine #(1,8,"sync") OPMODE_REG (OPMODE,clk,CEOPMODE,RSTOPMODE,OPMODE_OUT);
combine #(1,18,"sync") d_reg (D,clk,CED,RSTD,d_out);
mux2 #(18,"DIRECT") multiplexer (B,BCIN,b_before);
combine #(0,18,"sync") b0_reg (b_before,clk,CEB,RSTB,b0_out);
combine #(0,18,"sync") a0_reg (A,clk,CEA,RSTA,a0_out);
combine #(1,48,"sync") c_reg (C,clk,CEC,RSTC,c_out);
assign pre_op=(OPMODE_OUT[6]==0)?(d_out+b0_out):(d_out-b0_out);
assign pre_out=(OPMODE_OUT[4]==0)?b0_out:pre_op;
combine #(1,18,"sync") b1_reg  (pre_out,clk,CEB,RSTB,b1_out);
combine #(1,18,"sync") a1_reg(a0_out,clk,CEA,RSTA,a1_out);
assign BCOUT=b1_out;
assign X_={d_out[11:0],a1_out[17:0],b1_out[17:0]};
assign mult_out=a1_out*b1_out;


combine #(1,36,"sync") m_reg (mult_out,clk,CEM,RSTM,m_out);
assign M=m_out;
assign M_OUT=(m_out)&(48'h000fffffffff);
always @ (*) begin
    if (CARRYINSEL=="OPMODE5") begin
    flag=1;
    cascade_out=OPMODE[5];
    end
    else if (CARRYINSEL=="CARRYIN") begin
        flag=2;
    cascade_out= CARRYIN;
    end
    else begin
    cascade_out=0;
    flag=3;
    end
end
combine #(1,1,"sync") CYI(cascade_out,clk,CECARRYIN,RSTCARRYIN,cyi_out);
mux4 #(48) x_mult (48'b0,M_OUT,P,X_,OPMODE_OUT [1:0],x_out);
mux4 #(48) z_mult (48'b0,PCIN,P,c_out,OPMODE_OUT [3:2],z_out);
assign {cout1,post_out1}=x_out+z_out+cyi_out;
assign {cout2,post_out2}=z_out-(x_out+cyi_out);
assign cout =(OPMODE_OUT [7]==0)?cout1:cout2;
assign post_out =(OPMODE_OUT [7]==0)?post_out1:post_out2;





combine #(1,1,"sync") C_cas(cout,clk,CECARRYIN,RSTCARRYIN,CARRYOUT);
assign CARRYOUTF=CARRYOUT;
combine  #(1,48,"sync") P_REG (post_out,clk,CEP,RSTP,P);
assign PCOUT=P;




    
endmodule