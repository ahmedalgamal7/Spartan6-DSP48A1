module DSP_tb ();
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
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
reg clk,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
wire [17:0] BCOUT;
wire [47:0] PCOUT,P;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;
DSP #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,rsttype) dut (A,B,D,C,clk,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,
CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
initial begin
    RSTA=1;RSTB=1;RSTM=1;RSTP=1;RSTC=1;RSTD=1;RSTCARRYIN=1;RSTOPMODE=1;
    CEA=1;CEB=1;CEM=1;CEP=1;CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
    repeat (8)begin
         @(negedge clk);
    end
          RSTA=0;RSTB=0;RSTM=0;RSTP=0;RSTC=0;RSTD=0;RSTCARRYIN=0;RSTOPMODE=0;
          D=5;B=7;A=3;C=2;
          OPMODE=8'b00010101;PCIN=6;BCIN=1;CARRYIN=1;
           repeat (8)begin
         @(negedge clk);
    end
    // the expected p=42 ,bcout=12,carryout=0,
    OPMODE=8'b00011010;
     repeat (8)begin
         @(negedge clk);
     end
     // the expected p=84 ,bcout=12,carryout=0,

          D=5;B=7;A=3;C=2;
          OPMODE=8'b10010101;PCIN=6;BCIN=100;CARRYIN=1;
           repeat (8)begin
         @(negedge clk);
    end
// the expected p=-30
CEA=0;CEB=0;CEM=0;CEP=0;CEC=0;CED=0;CECARRYIN=0;CEOPMODE=0;
           repeat (8)begin
         @(negedge clk);
    end

   CEA=1;CEB=1;CEM=1;CEP=1;CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
D=50; B=17; A=37;C=2;
    OPMODE=8'b01111101;PCIN=6;BCIN=100;CARRYIN=1;
           repeat (8)begin
         @(negedge clk);
    end
    // the expected p=1224
$stop;
end
endmodule