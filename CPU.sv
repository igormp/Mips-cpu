module CPU (Clock, Reset, MemData, Address, WriteDataMem, WriteRegister, WriteDataReg, MDR, Alu, AluOut, PC,Estado,WOpcode,funct,WAluSrcA,WAluSrcB);
input Clock;
input Reset;

output wire [31:0] MemData;
output wire [31:0] Address;
output wire [31:0] WriteDataMem;
output wire [31:0] WriteRegister;
output wire [31:0] WriteDataReg;
output wire MDR;
output wire [31:0] Alu;
output wire [31:0] AluOut;
output wire [31:0] PC;
output wire [5:0] Estado;
output wire [5:0] WOpcode;
output wire [5:0] funct;
output wire [31:0] WAluSrcA;
output wire [31:0] WAluSrcB;

wire [15:0] WDesloc;
wire [15:0] WMemOutHIn;
wire [1:0] AluSrcA;
wire [1:0] MDRCtrl;
wire [25:0] W25_0;
wire [27:0] W27_0;
wire [2:0] AluCtrl; 
wire [2:0] AluSrcB;
wire [2:0] BigMux;
wire [2:0] IorD;
wire [2:0] MuxReg2;
wire [2:0] Shift;
wire [31:0] divhi;
wire [31:0] divlo;
wire [31:0] EntradaBALU;
wire [31:0] EntradaMem;
wire [31:0] highin;
wire [31:0] highout;
wire [31:0] lowin;
wire [31:0] lowout;
wire [31:0] MuxExit;
wire [31:0] SaidaA;  
wire [31:0] SaidaAI;
wire [31:0] SaidaB;
wire [31:0] SaidaBI;
wire [31:0] SaidaEPC;
wire [31:0] SaidaMDR;
wire [31:0] SaidaMDRI;
wire [31:0] SaidaRD;
wire [31:0] WA;
wire [31:0] WAI;
wire [31:0] WAluOut;
wire [31:0] WB;
wire [31:0] WBI;
wire [31:0] WCPC;
wire [31:0] WEPC;
wire [31:0] WHighIn;
wire [31:0] WHighOut;
wire [31:0] WLowIn;
wire [31:0] WLowOut;
wire [31:0] WLtOut;
wire [31:0] WMDR;
wire [31:0] WMDRI;
wire [31:0] WMemOutBOut;
wire [31:0] WMemOutHOut;
wire [31:0] WRD;
wire [31:0] WRDCtrlOut;
wire [31:0] WResultHighDiv;
wire [31:0] WResultHighMul;
wire [31:0] WResultLowDiv;
wire [31:0] WResultLowMul;
wire [31:0] WSEOut;
wire [31:0] WSL16In;
wire [31:0] WSL16Out;
wire [31:0] WSL2;
wire [31:0] WStoreIn;
wire [3:0] MuxReg1;
wire [4:0] W15_11;
wire [4:0] WB4_0;
wire [4:0] WRS;
wire [4:0] WRT;
wire [4:0] WShamtSrcOut;
wire [5:0] n;
wire [5:0] SaidaIR31_26;
wire [5:0] StateOut;
wire [5:0] W10_6;
wire [5:0] W5_0;
wire [7:0] WMemOutBIn;
wire AluOutCtrl;
wire DivIn;
wire DivOut;
wire DivZero;
wire e;
wire ec;
wire EPCCtrl;
wire HighCtrl;
wire IRWrite;
wire LowCtrl;
wire MemRead;
wire MultIn;
wire MultOut;
wire NegativoULA;
wire OpcodeInexistente;
wire Over;
wire OverControle;
wire OverflowULA;
wire PCWrite;
wire RDCtrl;
wire ResetA;
wire ResetAluOut;
wire ResetB;
wire ResetDiv;
wire ResetEPC;
wire ResetHigh;
wire ResetLow;
wire ResetMDR;
wire ResetMult;
wire ResetPC;
wire SaE;
wire SaET;
wire SetA;
wire SetB;
wire SetHigh;
wire SetLow;
wire ShamtSrc;
wire StoreCtrl;
wire WEt;
wire WGt;
wire WLt;
wire WriteDataCtrl;
wire WriteReg;
wire ZeroULA;

assign WMemOutBIn = MemData[7:0];
assign WMemOutHIn = MemData[15:0];
assign W10_6      = WDesloc[10:6];
assign W5_0       = WDesloc[5:0];
assign WB4_0      = WB[4:0];
assign W15_11     = WDesloc[15:11];

assign WCPC  = {PC[31:28], W27_0};
assign W25_0 = {WRS, WRT, WDesloc};

					
Controle controle (Clock, Reset, WOpcode, W5_0, PCWrite, IorD, StoreCtrl, WriteDataCtrl, MemRead,MDRCtrl, IRWrite, MDR, MuxReg1, MuxReg2, 
					RDCtrl, ShamtSrc, WriteReg, Shift, AluSrcA, AluSrcB, OverflowULA, WEt, WGt, WLt, MultIn, BigMux, HighCtrl, LowCtrl, AluCtrl, AluOutCtrl, EPCCtrl, ResetPC, ResetMDR, SetA, ResetA, SetB, ResetB, SetHigh, 
					ResetHigh, SetLow, ResetLow, ResetAluOut, ResetEPC, StateOut);
					
Registrador RPC (Clock,	ResetPC, PCWrite, MuxExit, PC);
Registrador RMDR (Clock, ResetMDR, MDR, WMDRI, WMDR);
Registrador RA (Clock, ResetA, SetA, WAI, WA);
Registrador RB (Clock, ResetB, SetB, WBI, WB);
Registrador RAluOut (Clock, ResetAluOut, AluOutCtrl, Alu, WAluOut);
Registrador REPC (Clock, ResetEPC, EPCCtrl, Alu, WEPC);
Registrador RHigh (Clock, ResetHigh, SetHigh, WHighIn, WHighOut);
Registrador RLow (Clock, ResetLow, SetLow, WLowIn, WLowOut);

//Mux

IorDMux MIorD(IorD, PC, WAI, WAluOut, Address);
MuxMDR MMDR(MDRCtrl, MemData, WMemOutBOut, WMemOutHOut, WMDRI);
MuxRegDes1 MRegDes1 (RDCtrl, WBI, WAI, WRDCtrlOut);
MuxLowControl MLowCtrl (LowCtrl, WResultLowMul, WResultLowDiv, WLowIn);
MuxHighControl MHighCtrl (HighCtrl, WResultHighMul, WResultHighDiv, WHighIn);
MuxBigMux MBigMux (BigMux, WMDRI, Alu, PC, WAluOut, WCPC, WEPC, MuxExit);
MuxALUSourceB MAluSrcB (AluSrcB, WB, WSEOut, WSL2, WRD, WAluSrcB);
MuxALUSourceA MAluSrcA (AluSrcA, PC, WMDR, WA, WAluSrcA);
MuxStore MStore (WriteDataCtrl, WStoreIn, WB, WriteDataMem);
MuxRegUm MRegUm (MuxReg1, WAluOut, WHighOut, WLowOut, WMDR, WRD, WLtOut, PC, WSL16Out, WriteDataReg);
MuxRegDes2 WRD2 (ShamtSrc, W10_6, WB4_0, WShamtSrcOut);
MuxRegDois MRegDois(MuxReg2, WRT, W15_11, WriteRegister);

Divisao div (WB, WA, WResultHighDiv, WResultLowDiv, DivIn, DivOut, DivZero, Clock, ResetDiv);
Multiplicador mult (WA, WB, WResultHighMul, WResultLowMul, MultIn, MultOut, Clock, ResetMult);

UnsignedExtend32 UE1_32 (WLt, WLtOut);
UnsignedExtend16 UE16_32 (WMemOutHIn, WMemOutHOut);
UnsignedExtend8 UE8_32 (WMemOutBIn, WMemOutBOut);

StoreControl Store (StoreCtrl, WMDR, WB, WStoreIn);

SignedExtend SE (WDesloc, WSEOut);

ShiftLeft16 SSL16(WSEOut, WSL16Out);

ShiftLeft2Conc SSL2C (W25_0, W27_0);

ShiftLeft2 SSL2(WSEOut, WSL2);

Banco_reg BR (Clock, Reset, WriteReg, WRS, WRT, WriteRegister, WriteDataReg, WAI, WBI);

Instr_Reg IR (Clock, Reset, IRWrite, MemData, WOpcode, WRS, WRT, WDesloc);

Memoria Mem (Address, Clock, MemRead, WriteDataMem, MemData);

RegDesloc RD (Clock, Reset, Shift, WShamtSrcOut, WRDCtrlOut, WRD);

ula32 ULA (WAluSrcA, WAluSrcB, AluCtrl, Alu, OverflowULA, NegativoULA, ZeroULA, WEt, WGt, WLt);

assign Estado       = StateOut;
assign SaidaPC      = PC;
assign EntradaMem   = Address;
assign SaidaMem     = MemData;
assign SaidaIR31_26 = WOpcode;
assign SaidaIR25_21 = WRS;
assign SaidaIR20_16 = WRT;
assign SaidaIR15_0  = WDesloc;
assign SaidaMDRI    = WMDRI;
assign SaidaMDR     = WMDR;
assign SaidaAI      = WAI;
assign SaidaBI      = WBI;
assign SaidaA       = WA;
assign SaidaB       = WB;
assign SaidaRD      = WRD;
assign SaidaALU     = Alu;
assign AluOut  = WAluOut;
assign SaidaEPC     = WEPC;
assign SaidaBigMux  = MuxExit;
assign SaidaHigh    = WHighOut;
assign SaidaLow     = WLowOut;
assign SaidaStore   = WStoreIn;
assign Reg1         = WriteDataReg;
assign Reg2         = WriteRegister;
assign gt           = WGt;
assign entrada      = WRDCtrlOut;
assign funct        = W5_0;
assign OverControle = ec;
assign Over         = OverflowULA;
assign SaET         = WEt;
assign SaE          = ec;
assign highin       = WHighIn;
assign highout      = WHighOut;
assign lowin        = WLowIn;
assign lowout       = WLowOut;
assign reh          = WResultHighMul;
assign rel          = WResultLowMul;
assign min          = MultIn;
assign mout         = MultOut;
assign divhi        = WResultHighDiv;
assign divlo        = WResultLowDiv;
assign n            = WShamtSrcOut;
assign e            = WEt;
assign eC           = ec;
assign EntradaBALU  = WAluSrcB;

endmodule


