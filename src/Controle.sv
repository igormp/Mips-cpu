module Controle (clk, Reset, Opcode, Funct, PCWrite, IorD, StoreCtrl, WriteDataCtrl, MemRead,
                    MDRCtrl, IRWrite, MDR, MuxReg1, MuxReg2, RDCtrl, ShamtSrc, WriteReg, Shift,
                    AluSrcA, AluSrcB, OverflowUla, ET, GT, LT, MultIn, BigMux, HighCtrl, LowCtrl, AluCtrl, AluOutCtrl, EPCCtrl, ResetPC, ResetMDR, SetA, ResetA, SetB,
                    ResetB, SetHigh, ResetHigh, SetLow, ResetLow, ResetAluOut, ResetEPC, StateOut);
                   
        // sinais de entrada
       
    input clk; 
    input Reset;
    input [5:0] Opcode;
    input [5:0] Funct;
    input OverflowUla;
    input GT;
    input LT;
    input ET;
   
        //Saída auxiliar (temporaria)
    output reg [5:0] StateOut;
   
        //sinais de saída
    output reg PCWrite;
    output reg StoreCtrl;
    output reg [2:0] IorD;
    output reg WriteDataCtrl;
    output reg MemRead;
    output reg IRWrite;
    output reg [1:0] MDRCtrl;
    output reg MDR;
    output reg [2:0] MuxReg2;
    output reg [3:0] MuxReg1;
    output reg RDCtrl;
    output reg ShamtSrc;
    output reg [2:0] Shift;
    output reg WriteReg;
    output reg [1:0] AluSrcA;
    output reg [2:0] AluSrcB;
    output reg [2:0] AluCtrl;
    output reg MultIn;
    output reg HighCtrl;
    output reg LowCtrl;
    output reg AluOutCtrl;
    output reg EPCCtrl;
    output reg ResetPC;
    output reg ResetMDR;
    output reg SetA;
    output reg ResetA;
    output reg SetB;
    output reg ResetB;
    output reg SetHigh;
    output reg ResetHigh;
    output reg SetLow;
    output reg ResetLow;
    output reg ResetAluOut;
    output reg ResetEPC;
    output reg [7:0] BigMux;
   
   
   
    // variável interna que armazena o estado
    reg [5:0] state;
    reg contador;
   
    //Escrever no reg
 
    parameter NOT_LOAD = 1'b0;
    parameter LOAD = 1'b1;
    parameter CLEAR = 1'b1;
    parameter NOT_CLEAR = 1'b0;
   
    // Ler na mem
   
    parameter READ = 1'b0;
    parameter WRITE = 1'b1;
 
    //IorD
 
    parameter IORD_PC = 3'b000;
    parameter IORD_AIMEDIATO = 3'b001;
    parameter IORD_ALUOUT = 3'b010;
    parameter IORD_OPCODEINEXISTENTE = 3'b011;
    parameter IORD_OVERFLOW = 3'b100;
    parameter IORD_DIVZERO = 3'b101;
 
    //WriteDataCtrl
 
    parameter WDC_STORE = 1'b0;
    parameter WDC_B = 1'b1;
 
    //MDRCtrl
 
    parameter MDRC_WORD = 2'b00;
    parameter MDRC_BYTE = 2'b01;
    parameter MDRC_HALF = 2'b10;
 
    // MuxReg2
 
    parameter MR2_RT = 3'b000;
    parameter MR2_31 = 3'b001;
    parameter MR2_29 = 3'b010;
    parameter MR2_RD = 3'b011;
    parameter MR2_30 = 3'b100;
 
    // MuxReg1
 
    parameter MR1_ALUOUT = 4'b0000;
    parameter MR1_HIGH = 4'b0001;
    parameter MR1_LOW = 4'b0010;
    parameter MR1_MDR = 4'b0011;
    parameter MR1_277 = 4'b0100;
    parameter MR1_RD = 4'b0101;
    parameter MR1_LT = 4'b0110;
    parameter MR1_PC = 4'b0111;
    parameter MR1_SL16 = 4'b1000;
    parameter MR_OVER1 = 4'b0001;
    parameter MR_OVER2 = 4'b0010;
 
    // RDCtrl
 
    parameter RDC_AIMEDIATO = 1'b1;
    parameter RDC_BIMEDIATO = 1'b0;
 
    // ShamtSrc
 
    parameter SHAMTSRC_SHAMT = 1'b0;
    parameter SHAMTSRC_BIMEDIATO = 1'b1;
 
    // AluSrcA
 
    parameter ALUSRCA_PC = 2'b00;
    parameter ALUSRCA_MDR = 2'b01;
    parameter ALUSRCA_A = 2'b10;
 
    // AluSrcB
 
    parameter ALUSRCB_B = 3'b000;
    parameter ALUSRCB_4 = 3'b001;
    parameter ALUSRCB_EXTEND = 3'b010;
    parameter ALUSRCB_SL2 = 3'b011;
    parameter ALUSRCB_RD = 3'b100;
 
    // HighCtrl
 
    parameter HIGH_MUL = 1'b0;
    parameter HIGH_DIV = 1'b1;
 
    // LowCtrl
 
    parameter LOW_MUL = 1'b0;
    parameter LOW_DIV = 1'b1;
 
    // BigMux
 
    parameter BIGMUX_MDRIMEDIATO = 8'b11111111;
    parameter BIGMUX_ALUOUTIMEDIATO = 3'b001;
    parameter BIGMUX_PC = 3'b010;
    parameter BIGMUX_ALUOUT = 3'b011;
    parameter BIGMUX_SL2 = 3'b100;
    parameter BIGMUX_EPC = 3'b101;
   
    // Store Ctrl
   
    parameter STORE_BYTE = 1'b0;
    parameter STORE_HALF = 1'b1;
   
   
    // Estados
   
    parameter RESET = 0;
    parameter BUSCA = 1;
    parameter WAIT = 2;
    parameter DECODIFICA = 3;
    parameter ADD = 4;
    parameter AND = 5;
    parameter XOR = 6;
    parameter SXORI = 7;
    parameter JR = 8;
    parameter MFHI = 9;
    parameter MFLO = 10;
    parameter SLL = 11;
    parameter SLLV = 12;
    parameter SLT = 13;
    parameter SRA = 14;
    parameter SRAV = 15;
    parameter SRL = 16;
    parameter SUB = 17;
    parameter BREAK = 18;
    parameter RET = 19;
    parameter ADDI = 20;
    parameter ADDIU = 21;
    parameter POS_S = 23;
    parameter WAIT_MEM = 24;
    parameter BEQM = 26;
    parameter LBU = 27;
    parameter LHU = 28;
    parameter LUI = 29;
    parameter LW = 30;
    parameter SB = 31;
    parameter SH  = 32;
    parameter SLTI = 33;
    parameter SW = 34;
    parameter J = 35;
    parameter JAL = 36;
    parameter ARIT_NOT_OVERFLOW_I = 37;
    parameter OPCODE_INEXISTENTE = 38;
    parameter OVERFLOW = 39;
    parameter ADDU = 40;
    parameter SUBU = 41;
    parameter WAIT_2 = 45;
    parameter ESCREVER_PC = 46;
    parameter WAIT_3 = 47;
    parameter ARIT_OVERFLOW = 48;
    parameter PRE_SLL_SRA = 49;
    parameter PRO_SHIFT = 50;
    parameter PRE_SLLV_SRAV = 51;
    parameter PRO_SRL = 52;
    parameter PRE_BRANCH = 53;
    parameter PRO_BRANCH = 54;
    parameter WAIT_4 = 55;
    parameter BEQM_2 = 56;
    parameter BEQM_3 = 57;
    parameter PRE_LS = 58;
    parameter PRO_LS = 59;
    parameter PRE_SB_SH_LW = 60;
    parameter WAIT_5 = 61;
    parameter RTE = 62;
    parameter STOPPC = 63;
    parameter WRITE_MEM = 64;
    parameter ANDI = 65;
   
   
    //ALU
   
    parameter ALU_LOAD = 0;
    parameter ALU_ADD = 1;
    parameter ALU_SUB = 2;
    parameter ALU_AND = 3;
    parameter ALU_INC = 4;
    parameter ALU_NOT = 5;
    parameter ALU_XOR = 6;
    parameter ALU_COMP = 7;
   
        // Opcode:
   
    parameter OP_R = 6'h0;
    parameter OP_ADDI = 6'h8;
    parameter OP_ADDIU = 6'h9;
    parameter OP_BEQ = 6'h4;
    parameter OP_RTE = 6'h10;
    parameter OP_BNE = 6'h5;
    parameter OP_BLE = 6'h6;
    parameter OP_BGT = 6'h7;
    parameter OP_BEQM = 6'h1;
    parameter OP_LBU = 6'h24;
    parameter OP_LHU = 6'h25;
    parameter OP_LUI = 6'hf;
    parameter OP_SXORI = 6'he;
    parameter OP_LW = 6'h23;
    parameter OP_SB = 6'h28;
    parameter OP_SH = 6'h29;
    parameter OP_SLTI = 6'ha;
    parameter OP_SW = 6'h2b;
    parameter OP_J = 6'h2;
    parameter OP_JAL = 6'h3;
    parameter OP_ANDI = 6'hc;
           
   
    //primeiro estado da máquina de estados: Reset
    initial begin
         state <= RESET;
    end
   
always @ (negedge clk) begin
    StateOut <= state;
    if (Reset) begin // se forcarem o reset
        state <= RESET;
    end else begin
        case(state)
       
            RESET: begin
           
            ResetPC <= CLEAR;
            ResetMDR <= CLEAR;
            ResetA <= CLEAR;
            ResetB <= CLEAR;
            ResetHigh <= CLEAR;
            ResetLow <= CLEAR;
            ResetAluOut <= CLEAR;
            ResetEPC <= CLEAR;
            MuxReg2 <= MR2_29;
            MuxReg1 <= MR1_277;
            WriteReg <= LOAD;
           
                // proximo estado
            state <= BUSCA;
           
            end
           
            BUSCA: begin
           
            WriteReg <= NOT_LOAD;
            ResetPC <= NOT_CLEAR;
            ResetMDR <= NOT_CLEAR;
            ResetA <= NOT_CLEAR;
            ResetB <= NOT_CLEAR;
            ResetHigh <= NOT_CLEAR;
            ResetLow <= NOT_CLEAR;
            ResetAluOut <= NOT_CLEAR;
            ResetEPC <= NOT_CLEAR;
            SetHigh <= NOT_LOAD;
            SetLow <= NOT_LOAD;
           
            MemRead <= READ;
            AluSrcA <= ALUSRCA_PC;
            AluSrcB <= ALUSRCB_4;
            AluCtrl <= ALU_ADD;
            BigMux <= BIGMUX_ALUOUTIMEDIATO;
            PCWrite <= LOAD;
            IorD <= IORD_PC;
           
                //proximo estado
            if(Opcode == 43 || Opcode == 40 || Opcode == 41 || Opcode == 35 || Opcode == 32 || Opcode == 33 || Opcode == 1 || Opcode == 37 || Opcode == 36) begin
                state <= WAIT_MEM;
            end else begin
                state <= WAIT; 
            end
           
            end
           
            WAIT: begin
           
            IRWrite <= LOAD;
            PCWrite <= NOT_LOAD;
           
                // proximo estado
            state <= DECODIFICA;
   
            end
           
            DECODIFICA: begin
           
            IRWrite <= NOT_LOAD;
            AluOutCtrl <= LOAD;
            AluSrcA <= ALUSRCA_PC;
            AluSrcB <= ALUSRCB_SL2;
            WriteReg <= NOT_LOAD;
            AluCtrl <= ALU_ADD;
            SetA <= LOAD;
            SetB <= LOAD;
           
            case(Opcode)
                OP_RTE: begin
                    state <= RTE;
                end
           
                OP_ADDI: begin
                    state <= ADDI;
                end
                
                OP_ANDI: begin
					state <= ANDI;
				end
               
                OP_ADDIU: begin
                    state <= ADDIU;
                end
               
                OP_BEQ: begin
                    state <= PRE_BRANCH;
                end
               
                OP_BNE: begin
                    state <= PRE_BRANCH;
                end
               
                OP_BLE: begin
                    state <= PRE_BRANCH;
                end
               
                OP_BGT: begin
                    state <= PRE_BRANCH;
                end
               
                OP_BEQM: begin
                    state <= BEQM;
                end
               
                OP_LBU: begin
                    state <= PRE_LS;
                end
               
                OP_LHU: begin
                    state <= PRE_LS;
                end
               
                OP_LUI: begin
                    state <= LUI;
                end
               
                OP_LW: begin
                    state <= PRE_LS;
                end
               
                OP_SB: begin
                    state <= PRE_LS;
                end
               
                OP_SH: begin
                    state <= PRE_LS;
                end
               
                OP_SLTI: begin
                    state <= SLTI;
                end
               
                OP_SW: begin
                    state <= PRE_LS;
                end
               
                OP_J: begin
                    state <= J;
                end
               
                OP_JAL: begin
                    state <= JAL;
                end
 
                OP_SXORI: begin
                  state <= SXORI;
                end
               
                OP_R: begin
                    case(Funct)
                        6'h20: begin
                            state <= ADD;
                        end
 
                        6'h21: begin
                          state <= ADDU;
                        end
                       
                        6'h23: begin
                          state <= SUBU;
                        end
                       
                        6'h24: begin
                            state <= AND;
                        end
                       
                        6'h8: begin
                            state <= JR;
                        end
                       
                        6'h10: begin
                            state <= MFHI;
                        end
                       
                        6'h12: begin
                            state <= MFLO;
                        end
                       
                        6'h0: begin
                            state <= PRE_SLL_SRA;
                        end
                       
                        6'h4: begin
                            state <= PRE_SLLV_SRAV;
                        end
                       
                        6'h2a: begin
                            state <= SLT;
                        end
                       
                        6'h3: begin
                            state <= PRE_SLL_SRA;
                        end
                       
                        6'h7: begin
                            state <= PRE_SLLV_SRAV;
                        end
                       
                        6'h2: begin
                            state <= SRL;
                        end
                       
                        6'h22: begin
                            state <= SUB;
                        end
                       
                        6'hd: begin
                            state <= BREAK;
                        end
                        6'h26: begin
                            state <= XOR;
                        end
                        
                    endcase
                end
               
                default: begin
                    state <= OPCODE_INEXISTENTE;
                end
                endcase
                               
            end // decodifica
           
            MFHI: begin
                IRWrite <= NOT_LOAD;
                MuxReg1 <= MR1_HIGH;
                MuxReg2 <= MR2_RD;
                WriteReg <= LOAD;
           
                    //proximo estado:
                state <= BUSCA;
            end
           
            MFLO: begin
                IRWrite <= NOT_LOAD;
                MuxReg1 <= MR1_LOW;
                MuxReg2 <= MR2_RD;
                WriteReg <= LOAD;
           
                    // proximo estado
                state <= BUSCA;
            end
           
            BREAK: begin
                IRWrite <= NOT_LOAD;
                AluSrcA <= ALUSRCA_PC;
                AluSrcB <= ALUSRCB_4;
                AluCtrl <= ALU_SUB;
                PCWrite <= NOT_LOAD;
           
                    // proximo estado
                state <= BREAK;
            end
           
            STOPPC: begin
                IRWrite <= NOT_LOAD;
                PCWrite <= NOT_LOAD;
                WriteReg <= NOT_LOAD;
                    // proximo estado
                state <= BUSCA;
            end
           
            WAIT_2: begin
                IRWrite <= NOT_LOAD;
               
                    //proximo estado:
            if(Opcode == OP_BEQ || Opcode == OP_BNE || Opcode == OP_BLE || Opcode == OP_BGT || Opcode == OP_BEQM) begin
                        if((ET == 1 && Opcode == OP_BEQ) ||(ET == 0 && Opcode == OP_BNE) ||
                            (GT == 0 && Opcode == OP_BLE) || (GT == 1 && Opcode == OP_BGT) ||
                            (ET == 1 && Opcode == OP_BEQM)) begin
                            state <= PRO_BRANCH;
                        end else begin
                            state <= BUSCA;
                        end
            end else if (Opcode == OP_R) begin
                    if (Funct == 6'h20 || Funct == 6'h22) begin
                        if(OverflowUla == 1'b0) begin
                        state <= ARIT_NOT_OVERFLOW_I;
												end 
						else begin
                        state <= ARIT_OVERFLOW;
								end
															end // funct
					
                    else if (Funct == 6'h21 || Funct == 6'h23 || Funct == 6'h24 || Funct == 6'h26) begin
                        state <= ARIT_NOT_OVERFLOW_I;
                    end
            end else if (Opcode == OP_ADDI) begin
                    if(OverflowUla == 1'b1) begin
                        state <= ARIT_OVERFLOW;
                    end else begin
                        state <= ARIT_NOT_OVERFLOW_I;
                    end
                end
            end
           
           
            OPCODE_INEXISTENTE: begin
                IRWrite <= NOT_LOAD;
                AluSrcA <= ALUSRCA_PC;
                AluSrcB <= ALUSRCB_4;
                AluCtrl <= ALU_SUB;
                EPCCtrl <= LOAD;
                IorD <= IORD_OPCODEINEXISTENTE;
                MemRead <= READ;
               
                //proximo estado:
                state <= WAIT_3;   
            end
           
            WAIT_3: begin
                IRWrite <= NOT_LOAD;
                EPCCtrl <= NOT_LOAD;
               
                    //proximo estado:
                if(Opcode == OP_ADDI) begin
					MuxReg1 = MR_OVER1;
					WriteReg = LOAD;
					MuxReg2 = MR2_30;
					state <= ESCREVER_PC;
				end
                if(Opcode == OP_R && Funct == 6'h20) begin
					MuxReg1 = MR_OVER2;
					WriteReg = LOAD;
					MuxReg2 = MR2_30;
					state <= ESCREVER_PC;
				end
				if(Opcode == 38) begin
					MuxReg1 = MR_OVER2;
					WriteReg = LOAD;
					MuxReg2 = MR2_30;
					state <= ESCREVER_PC;
				end
            end
           
            ESCREVER_PC: begin
                IRWrite <= NOT_LOAD;
                MDRCtrl <= MDRC_BYTE;
                BigMux <= BIGMUX_MDRIMEDIATO;
                PCWrite <= LOAD;
               
                    //proximo estado:
                state <= STOPPC;
            end
           
            ADDI: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_ADD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
               
                    //proximo estado:
                    state <= WAIT_2;
            end
           
            ANDI: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_AND;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
               
                    //proximo estado:
                    state <= ARIT_NOT_OVERFLOW_I;
            end
     
            SXORI: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_XOR;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
               
                    //proximo estado:
                    state <= WAIT_2;
            end
 
            ARIT_OVERFLOW: begin
                IRWrite <= NOT_LOAD;
                AluSrcA = ALUSRCA_PC;
                AluSrcB = ALUSRCB_4;
                AluCtrl = ALU_SUB;
                EPCCtrl = LOAD;
                IorD = IORD_OVERFLOW;
                MemRead <= READ;
                   
                    //proximo estado
                state <= WAIT_3;
            end
           
            ARIT_NOT_OVERFLOW_I: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                if(Opcode == OP_R) begin
                MuxReg2 <= MR2_RD;
                end else begin
                MuxReg2 <= MR2_RT;
                end
                MuxReg1 <= MR1_ALUOUT;
                WriteReg <= LOAD;
               
                    // proximo estado
                state <= BUSCA;
            end
           
            ADD: begin
                IRWrite <= NOT_LOAD;
                SetA <= NOT_LOAD;
                SetB <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_ADD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                //proximo estado:
                    state <= WAIT_2;
            end
     
            ADDU: begin
                IRWrite <= NOT_LOAD;
                SetA <= NOT_LOAD;
                SetB <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_ADD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                //proximo estado:
                    state <= WAIT_2;
            end
 
            XOR: begin
                IRWrite <= NOT_LOAD;
                SetA <= NOT_LOAD;
                SetB <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_XOR;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                //proximo estado:
                    state <= WAIT_2;
            end
           
            SUB: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_SUB;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                        //proximo estado:
                    state <= WAIT_2;
            end
         
            SUBU: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_SUB;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                        //proximo estado:
                    state <= WAIT_2;
            end
           
            ADDIU: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_ADD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
               
                        //proximo estado:
                    state <= ARIT_NOT_OVERFLOW_I;
            end
           
            AND: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= LOAD;
                AluCtrl <= ALU_AND;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
               
                        //proximo estado:
                    state <= ARIT_NOT_OVERFLOW_I;
            end
           
            PRE_SLL_SRA: begin
                IRWrite <= NOT_LOAD;
                SetA <= NOT_LOAD;
                SetB <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                RDCtrl <= RDC_BIMEDIATO;
                ShamtSrc <= SHAMTSRC_SHAMT;
                Shift <= 3'b001; // load
               
                        //proximo estado:
                    if(Funct == 3'h0) begin
                        state <= SLL;
                    end else begin
                        state <= SRA;
                    end
            end
           
            SLL: begin
                IRWrite <= NOT_LOAD;
                Shift <= 3'b010;
               
                    // proximo estado
                state <= PRO_SHIFT;
            end
           
            SRA: begin
                IRWrite <= NOT_LOAD;
                Shift <= 3'b100;
               
                    // proximo estado
                state <= PRO_SHIFT;
            end
           
            PRO_SHIFT: begin
                IRWrite <= NOT_LOAD;
                WriteReg = LOAD;
                MuxReg1 = MR1_RD;
                MuxReg2 = MR2_RD;
           
                    // proximo estado
                state <= BUSCA;
            end
           
            PRE_SLLV_SRAV: begin
                IRWrite <= NOT_LOAD;
                SetA <= NOT_LOAD;
                SetB <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                RDCtrl <= RDC_AIMEDIATO;
                ShamtSrc <= SHAMTSRC_BIMEDIATO;
                Shift <= 3'b001; // load
               
                        //proximo estado:
                    if(Funct == 3'h4) begin
                        state <= SLLV;
                    end else begin
                        state <= SRAV;
                    end
            end
           
            SLLV: begin
                IRWrite <= NOT_LOAD;
                Shift <= 3'b010;
               
                    // proximo estado
                state <= PRO_SHIFT;
            end
           
            SRAV: begin
                IRWrite <= NOT_LOAD;
                Shift <= 3'b100;
               
                    // proximo estado
                state <= PRO_SHIFT;
            end
           
            SRL: begin
                IRWrite <= NOT_LOAD;
                RDCtrl <= RDC_BIMEDIATO;
                ShamtSrc <= SHAMTSRC_SHAMT;
                Shift <= 3'b001; // load
               
                    // proximo estado
                state <= PRO_SRL;
            end
           
            PRO_SRL: begin
                IRWrite <= NOT_LOAD;
                Shift <= 3'b011;
           
                    // proximo estado
                state <= PRO_SHIFT;
            end
           
            LUI: begin
                IRWrite <= NOT_LOAD;
                MuxReg1 <= MR1_SL16;
                MuxReg2 <= MR2_RT;
                WriteReg = LOAD;
           
                    // proximo estado
                state <= BUSCA;
            end
           
            RTE: begin
                IRWrite <= NOT_LOAD;
                BigMux <= BIGMUX_EPC;
                PCWrite <= LOAD;
           
                    // proximo estado
                state <= STOPPC;
            end
           
            J: begin
                IRWrite <= NOT_LOAD;
                BigMux <= BIGMUX_SL2;
                PCWrite <= LOAD;
           
                    // proximo estado
                state <= STOPPC;
            end
           
            JAL: begin
                IRWrite <= NOT_LOAD;
                MuxReg1 <= MR1_PC;
                MuxReg2 <= MR2_31;
                BigMux <= BIGMUX_SL2;
                PCWrite <= LOAD;
                WriteReg <= LOAD;
           
                    // proximo estado
                state <= STOPPC;
            end
           
            JR: begin
                IRWrite <= NOT_LOAD;
                AluCtrl <= ALU_LOAD;
                BigMux <= BIGMUX_ALUOUTIMEDIATO;
                PCWrite <= LOAD;
                AluSrcA <= ALUSRCA_A;
           
                    // proximo estado
                state <= STOPPC;
            end
           
            SLT: begin
                IRWrite <= NOT_LOAD;
                WriteReg <= LOAD;
                AluCtrl <= ALU_COMP;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
                MuxReg1 <= MR1_LT;
                MuxReg2 <= MR2_RD;
           
                    // proximo estado
                state <= BUSCA;
            end
           
            SLTI: begin
                IRWrite <= NOT_LOAD;
                AluCtrl <= ALU_COMP;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
                if (GT == 1)begin
                    WriteReg <= LOAD;
                    MuxReg1 <= MR1_LT;
                    MuxReg2 <= MR2_RT;
                end
                    // proximo estado
                state <= BUSCA;
            end
 
            PRE_BRANCH: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_B;
                AluCtrl <= ALU_COMP;
           
                    // proximo estado
                        state <= WAIT_2;
                   
            end
 
            PRO_BRANCH: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                BigMux <= BIGMUX_ALUOUT;
                PCWrite <= LOAD;
               
                    // proximo estado
                state <= STOPPC;
            end
           
            BEQM: begin
                IRWrite <= NOT_LOAD;
                IorD <= IORD_AIMEDIATO;
                MemRead <= READ;
                AluOutCtrl <= NOT_LOAD;
               
                    // proximo estado
                state <= WAIT_4;
            end
           
            WAIT_4: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
       
                    // proximo estado
                state <= BEQM_2;
            end
           
            BEQM_2: begin
                IRWrite <= NOT_LOAD;
                MDRCtrl <= MDRC_WORD;
                MDR <= LOAD;
                AluOutCtrl <= NOT_LOAD;
       
                    // proximo estado
                state <= BEQM_3;
            end
           
            BEQM_3: begin
                IRWrite <= NOT_LOAD;
                AluSrcA <= ALUSRCA_MDR;
                AluSrcB <= ALUSRCB_B;
                AluCtrl <= ALU_COMP;
                AluOutCtrl <= NOT_LOAD;
       
                    // proximo estado
                state <= WAIT_2;
            end
           
            PRE_LS: begin
                IRWrite <= NOT_LOAD;
                AluSrcA <= ALUSRCA_A;
                AluSrcB <= ALUSRCB_EXTEND;
                AluCtrl <= ALU_ADD;
                AluOutCtrl <= LOAD;
       
                    // proximo estado
                    if(Opcode == OP_SW) begin
                        state <= SW;
                end else begin
                        state <= PRO_LS;
                end
            end
           
            SW: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                IorD <= IORD_ALUOUT;
                WriteDataCtrl <= WDC_B;
                MemRead <= WRITE;
                    // proximo estado
                state <= BUSCA;
            end
           
            WAIT_MEM: begin
                IRWrite <= NOT_LOAD;
                PCWrite <= NOT_LOAD;
                MemRead <= READ;
                    // proximo estado
                state <= WAIT;
            end
           
            PRO_LS: begin
                IRWrite <= NOT_LOAD;
                AluOutCtrl <= NOT_LOAD;
                IorD <= IORD_ALUOUT;
                MemRead <= READ;
               
                    // proximo estado
                state <= WAIT_5;
            end
           
            WAIT_5: begin
                IRWrite <= NOT_LOAD;
                        // proximo estado
                    if(Opcode == OP_SB || Opcode == OP_SH || Opcode == OP_LW) begin
                        state <= PRE_SB_SH_LW;
                    end else if (Opcode == OP_LBU) begin
                        state <= LBU;
                    end else if (Opcode == OP_LHU) begin
                        state <= LHU;
                    end
            end
           
            PRE_SB_SH_LW: begin
                IRWrite <= NOT_LOAD;
                MDRCtrl <= MDRC_WORD;
                MDR <= LOAD;
               
                    // proximo estado
                if(Opcode == OP_SB) begin
                    state <= SB;
                end else if (Opcode == OP_SH) begin
                    state <= SH;
                end else if (Opcode == OP_LW) begin
                    state <= LW;
                end            
            end
 
            SB: begin
                IRWrite <= NOT_LOAD;
                IorD <= IORD_ALUOUT;
                MDR <= NOT_LOAD;
                StoreCtrl <= STORE_BYTE;
                WriteDataCtrl <= WDC_STORE;
                MemRead <= WRITE;
               
                    // proximo estado
                state <= BUSCA;
            end
           
            WRITE_MEM: begin
                IRWrite <= NOT_LOAD;
                MemRead <= WRITE;
                    // proximo estado
                state <= BUSCA;
            end
           
            SH: begin
                IRWrite <= NOT_LOAD;
                IorD <= IORD_ALUOUT;
                MDR <= NOT_LOAD;
                StoreCtrl <= STORE_HALF;
                WriteDataCtrl <= WDC_STORE;
                MemRead <= WRITE;
               
                    // proximo estado
                state <= BUSCA;
            end
           
            LW: begin
                IRWrite <= NOT_LOAD;
                MDR <= NOT_LOAD;
                MuxReg1 <= MR1_MDR;
                MuxReg2 <= MR2_RT;
                WriteReg <= LOAD;
               
                    // proximo estado
                state <= BUSCA;
            end
           
            LBU: begin
                IRWrite <= NOT_LOAD;
                MDRCtrl <= MDRC_BYTE;
                MDR <= LOAD;               
                    // proximo estado
                state <= LW;
            end
           
            LHU: begin
                IRWrite <= NOT_LOAD;
                MDRCtrl <= MDRC_HALF;
                MDR <= LOAD;
               
                    // proximo estado
                state <= LW;
            end
           
 
        endcase
    end // qnd n eh reset
end // always
   
endmodule