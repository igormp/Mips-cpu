--------------------------------------------------------------------------------
-- Title		: Unidade de Lógica e Aritmética
-- Project		: CPU multi-ciclo
--------------------------------------------------------------------------------
-- File			: ula32.vhd
-- Author		: Emannuel Gomes Macêdo (egm@cin.ufpe.br)
--				  Fernando Raposo Camara da Silva (frcs@cin.ufpe.br)
--				  Pedro Machado Manhães de Castro (pmmc@cin.ufpe.br)
--				  Rodrigo Alves Costa (rac2@cin.ufpe.br)
-- Organization : Universidade Federal de Pernambuco
-- Created		: 29/07/2002
-- Last update	: 21/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade que processa as operações lógicas e aritméticas da
-- cpu.
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 1
-- Revision Number	: 1
-- Version			: 1.1
-- Date				: 21/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado (mvlm@cin.ufpe.br)
--				   	  Paulo Roberto Santana Oliveira Filho (prsof@cin.ufpe.br)
--					  Viviane Cristina Oliveira Aureliano (vcoa@cin.ufpe.br)
-- Description		:
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 2
-- Revision Number	: 1.1
-- Version			: 1.2
-- Date				: 18/08/2008
-- Modifier			: João Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Entradas, saídas e sinais internos passam a ser std_logic.
--------------------------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-- Short name: ula
entity Ula32 is
	port ( 
		A 			: in  std_logic_vector (31 downto 0);	-- Operando A da ULA
		B 			: in  std_logic_vector (31 downto 0);	-- Operando B da ULA
		Seletor 	: in  std_logic_vector (2 downto 0);	-- Seletor da operação da ULA
		S 			: out std_logic_vector (31 downto 0);	-- Resultado da operação (SOMA, SUB, AND, NOT, INCREMENTO, XOR)  
		Overflow 	: out std_logic;						-- Sinaliza overflow aritmético
		Negativo	: out std_logic;						-- Sinaliza valor negativo
		z 			: out std_logic;						-- Sinaliza quando S for zero
		Igual		: out std_logic;						-- Sinaliza se A=B
		Maior		: out std_logic;						-- Sinaliza se A>B
		Menor		: out std_logic 						-- Sinaliza se A<B
	);
end Ula32;

-- Simulation
architecture behavioral of Ula32 is
	
	signal s_temp		: std_logic_vector (31 downto 0);	-- Sinal que recebe valor temporário da operação realizada
 	signal soma_temp 	: std_logic_vector (31 downto 0);   -- Sinal que recebe o valor temporario da soma, subtração ou incremento
	signal carry_temp	: std_logic_vector (31 downto 0);   -- Vetor para auxílio no cálculo das operações e do overflow aritmético 
	signal novo_B 		: std_logic_vector (31 downto 0);   -- Vetor que fornece o operando B, 1 ou not(B) para operações de soma, incremento ou subtração respectivamente
	signal i_temp		: std_logic_vector (31 downto 0);   -- Vetor para calculo de incremento
	signal igual_temp	: std_logic;						-- Bit que armazena instancia temporária de igualdade
	signal overflow_temp: std_logic;						-- Bit que armazena valor temporário do overflow

	begin

		with Seletor select
	
			s_temp <= 	A  			when "000", -- LOAD
			  			soma_temp  	when "001",	-- SOMA
			  			soma_temp   when "010",	-- SUB
			  			(A and B)  	when "011",	-- AND
			  			(A xor B) 	when "110", -- A XOR B              
              			not(A)     	when "101",	-- NOT A
			  			soma_temp  	when "100",	-- INCREMENTO			  
             			"00000000000000000000000000000000" when others;  	-- NAO DEFINIDO
			
			S <= s_temp;
			
			Negativo <= s_temp(31);
			
			i_temp <= "00000000000000000000000000000001";
			
			z <= '1' when s_temp = "00000000000000000000000000000000" else '0';

--------------------------------------------------------------------------------
--		Regiao que calcula a soma, subtracao e incremento					  --	
--------------------------------------------------------------------------------
		with Seletor select
    		
			novo_B <= B  		when "001",  -- Soma
   				      i_temp 	when "100",  -- Incremento
                      not(B) 	when others; -- Subtracao e outros	
  	
    		soma_temp(0) <= A(0) xor novo_B(0) xor seletor(1);
			soma_temp(1) <= A(1) xor novo_B(1) xor carry_temp(0);
			soma_temp(2) <= A(2) xor novo_B(2) xor carry_temp(1);
			soma_temp(3) <= A(3) xor novo_B(3) xor carry_temp(2);
			soma_temp(4) <= A(4) xor novo_B(4) xor carry_temp(3);
			soma_temp(5) <= A(5) xor novo_B(5) xor carry_temp(4);
			soma_temp(6) <= A(6) xor novo_B(6) xor carry_temp(5);
			soma_temp(7) <= A(7) xor novo_B(7) xor carry_temp(6);
			soma_temp(8) <= A(8) xor novo_B(8) xor carry_temp(7);
			soma_temp(9) <= A(9) xor novo_B(9) xor carry_temp(8);
			soma_temp(10) <= A(10) xor novo_B(10) xor carry_temp(9);
			soma_temp(11) <= A(11) xor novo_B(11) xor carry_temp(10);
			soma_temp(12) <= A(12) xor novo_B(12) xor carry_temp(11);
			soma_temp(13) <= A(13) xor novo_B(13) xor carry_temp(12);
			soma_temp(14) <= A(14) xor novo_B(14) xor carry_temp(13);
			soma_temp(15) <= A(15) xor novo_B(15) xor carry_temp(14);
			soma_temp(16) <= A(16) xor novo_B(16) xor carry_temp(15);
			soma_temp(17) <= A(17) xor novo_B(17) xor carry_temp(16);
			soma_temp(18) <= A(18) xor novo_B(18) xor carry_temp(17);
			soma_temp(19) <= A(19) xor novo_B(19) xor carry_temp(18);
			soma_temp(20) <= A(20) xor novo_B(20) xor carry_temp(19);
			soma_temp(21) <= A(21) xor novo_B(21) xor carry_temp(20);
			soma_temp(22) <= A(22) xor novo_B(22) xor carry_temp(21);
			soma_temp(23) <= A(23) xor novo_B(23) xor carry_temp(22);
			soma_temp(24) <= A(24) xor novo_B(24) xor carry_temp(23);
			soma_temp(25) <= A(25) xor novo_B(25) xor carry_temp(24);
			soma_temp(26) <= A(26) xor novo_B(26) xor carry_temp(25);
			soma_temp(27) <= A(27) xor novo_B(27) xor carry_temp(26);
			soma_temp(28) <= A(28) xor novo_B(28) xor carry_temp(27);
			soma_temp(29) <= A(29) xor novo_B(29) xor carry_temp(28);
			soma_temp(30) <= A(30) xor novo_B(30) xor carry_temp(29);
			soma_temp(31) <= A(31) xor novo_B(31) xor carry_temp(30);
      

			carry_temp(0) <=    (seletor(1) and (A(0) or novo_B(0))) or (A(0) and novo_B(0));
	    	carry_temp(1) <= (carry_temp(0) and (A(1) or novo_B(1))) or (A(1) and novo_B(1));
			carry_temp(2) <= (carry_temp(1) and (A(2) or novo_B(2))) or (A(2) and novo_B(2));
			carry_temp(3) <= (carry_temp(2) and (A(3) or novo_B(3))) or (A(3) and novo_B(3));
			carry_temp(4) <= (carry_temp(3) and (A(4) or novo_B(4))) or (A(4) and novo_B(4));
			carry_temp(5) <= (carry_temp(4) and (A(5) or novo_B(5))) or (A(5) and novo_B(5));
			carry_temp(6) <= (carry_temp(5) and (A(6) or novo_B(6))) or (A(6) and novo_B(6));
			carry_temp(7) <= (carry_temp(6) and (A(7) or novo_B(7))) or (A(7) and novo_B(7));
			carry_temp(8) <= (carry_temp(7) and (A(8) or novo_B(8))) or (A(8) and novo_B(8));
		    carry_temp(9) <= (carry_temp(8) and (A(9) or novo_B(9))) or (A(9) and novo_B(9));
			carry_temp(10) <= (carry_temp(9) and (A(10) or novo_B(10))) or (A(10) and novo_B(10));
			carry_temp(11) <= (carry_temp(10) and (A(11) or novo_B(11))) or (A(11) and novo_B(11));
			carry_temp(12) <= (carry_temp(11) and (A(12) or novo_B(12))) or (A(12) and novo_B(12));
			carry_temp(13) <= (carry_temp(12) and (A(13) or novo_B(13))) or (A(13) and novo_B(13));
			carry_temp(14) <= (carry_temp(13) and (A(14) or novo_B(14))) or (A(14) and novo_B(14));
			carry_temp(15) <= (carry_temp(14) and (A(15) or novo_B(15))) or (A(15) and novo_B(15));
			carry_temp(16) <= (carry_temp(15) and (A(16) or novo_B(16))) or (A(16) and novo_B(16));
		    carry_temp(17) <= (carry_temp(16) and (A(17) or novo_B(17))) or (A(17) and novo_B(17));
			carry_temp(18) <= (carry_temp(17) and (A(18) or novo_B(18))) or (A(18) and novo_B(18));
			carry_temp(19) <= (carry_temp(18) and (A(19) or novo_B(19))) or (A(19) and novo_B(19));
			carry_temp(20) <= (carry_temp(19) and (A(20) or novo_B(20))) or (A(20) and novo_B(20));
			carry_temp(21) <= (carry_temp(20) and (A(21) or novo_B(21))) or (A(21) and novo_B(21));
			carry_temp(22) <= (carry_temp(21) and (A(22) or novo_B(22))) or (A(22) and novo_B(22));
			carry_temp(23) <= (carry_temp(22) and (A(23) or novo_B(23))) or (A(23) and novo_B(23));
			carry_temp(24) <= (carry_temp(23) and (A(24) or novo_B(24))) or (A(24) and novo_B(24));
		    carry_temp(25) <= (carry_temp(24) and (A(25) or novo_B(25))) or (A(25) and novo_B(25));
			carry_temp(26) <= (carry_temp(25) and (A(26) or novo_B(26))) or (A(26) and novo_B(26));
			carry_temp(27) <= (carry_temp(26) and (A(27) or novo_B(27))) or (A(27) and novo_B(27));
			carry_temp(28) <= (carry_temp(27) and (A(28) or novo_B(28))) or (A(28) and novo_B(28));
			carry_temp(29) <= (carry_temp(28) and (A(29) or novo_B(29))) or (A(29) and novo_B(29));
			carry_temp(30) <= (carry_temp(29) and (A(30) or novo_B(30))) or (A(30) and novo_B(30));
			carry_temp(31) <= (carry_temp(30) and (A(31) or novo_B(31))) or (A(31) and novo_B(31));

			overflow_temp <= carry_temp(31) xor carry_temp(30);
		
		   Overflow <= overflow_temp;

--------------------------------------------------------------------------------
--		Regiao que calcula a comparação										  --	
--------------------------------------------------------------------------------

-- No codigo da comparacao (110) sera executada a subtracao na parte relativa

-- ao calculo da SOMA, SUBTRACAO e INCREMENTO.

		
		igual_temp <= not(overflow_temp)  when soma_temp = "00000000000000000000000000000000" 
					else '0'; -- Quando subtracao e zero
  		
  		Igual <= igual_temp; 

-- Se nao teve overflow -> resultado baseado no bit mais significativo de A - B.
-- Se teve overflow -> A e B possuem, necessariamente, sinais contrarios. Resultado 
-- baseado no bit mais significativo de A.
-- Devemos tambem checar se A e B nao sao iguais
		Maior <= ( (not(soma_temp(31)) and (not(overflow_temp)) )or (overflow_temp and (not(A(31))))) and (not(igual_temp));

-- Se nao teve overflow -> resultado baseado no bit mais significativo de A - B.
-- Se teve overflow -> A e B possuem, necessariamente, sinais contrarios. Resultado 
-- baseado no bit mais significativo de A.
		Menor <= ((soma_temp(31) and (not(overflow_temp))) or (overflow_temp and A(31)));


end behavioral;
