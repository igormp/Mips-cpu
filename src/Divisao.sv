module Divisao (
input[31:0] Divisor, input[31:0] Dividendo,
output reg[31:0] Hi, output reg[31:0] Lo,
input divIn, output reg divOut, output reg divZero,
input clock, input reset );

reg signed[31:0] A, Q, M, Support;
reg working, select, signal, signalEnd;
reg[5:0] contador;

always@(negedge clock)
begin

if(reset == 0)
begin

    case(working)
    1'b0:
    begin
        Q = Dividendo;
        A = 32'b11111111111111111111111111111111;
        if(Q[31] == 0)
        begin
            A = 0;
        end
        
        M = Divisor;
        divOut <= 1'b0;
        
        if(divIn == 1)
        begin
            if(M == 0)
            begin
                divZero <= 1;
            end
            else
            begin
                working <= 1'b1;
                
                {A, Q} = {A, Q} << 1;
                
                Support = A^M;
                signalEnd = Support[31];
                signal = A[31];

                if(Support>=0)
                begin
                    A = A - M;
                    select = 0;
                end
                else
                begin
                    A = A + M;
                    select = 1;
                end
                
                if((((A < 0) && (signal == 1)) || ((A>=0) && (signal == 0))) || ((A == 0) && (Q == 0)))
                begin
                    
                    Q = Q + 1;
                    
                end
                else
                begin
                    
                    if(select == 0)
                    begin
                        A = A + M;
                    end
                    else
                    begin
                        A = A - M;
                    end
                    
                end
                contador = 31;
            end
        end
    end
    1'b1:
    begin
        
        {A, Q} = {A, Q} << 1;
        
        
        Support = A^M;
        
        signal = A[31];

        if(Support>=0)
        begin
            A = A - M;
            select = 0;
        end
        else
        begin
            A = A + M;
            select = 1;
        end
        
        if((((A < 0) && (signal == 1)) || ((A>=0) && (signal == 0))) || ((A == 0) && (Q == 0)))
        begin
            
            Q = Q + 1;
            
        end
        else
        begin
            
            if(select == 0)
            begin
                A = A + M;
            end
            else
            begin
                A = A - M;
            end
            
        end
        contador = contador - 1;
        
        if(contador == 0)
        begin
            working <= 1'b0;
            
            if(signalEnd ==1)
            begin
                Q = -Q;
            end
            
            if(A < 0)
            begin
            
                if(M < 0)
                begin
                    A = A - M;
                end
                else
                begin
                    A = A + M;
                end
                
                if(Q < 0)
                begin
                    Q = Q - 1;
                end
                else
                begin
                    Q = Q + 1;
                end
                
            end
            
            Lo <= Q;
            Hi <= A;
            
            divOut <= 1'b1;
            
        end
        else
        begin
            divOut <= 1'b0;
        end
    end
    endcase

end
else
begin

    A         <= 0;
    Q         <= 0;
    M         <= 0;
    Support   <= 0;
    working   <= 0;
    select    <= 0;
    signal    <= 0;
    signalEnd <= 0;
    contador  <= 0;
    Hi        <= 0;
    Lo        <= 0;
    divOut    <= 0;
    divZero   <= 0;
    
end    

end
endmodule
