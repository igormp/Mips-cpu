--------------------------------------------------------------------------------
-- Title		: Registrador de Intruções
-- Project		: CPU multi-ciclo
--------------------------------------------------------------------------------
-- File			: instr_reg.vhd
-- Author		: Marcus Vinicius Lima e Machado (mvlm@cin.ufpe.br)
--				  Paulo Roberto Santana Oliveira Filho (prsof@cin.ufpe.br)
--				  Viviane Cristina Oliveira Aureliano (vcoa@cin.ufpe.br)
-- Organization : Universidade Federal de Pernambuco
-- Created		: 29/07/2002
-- Last update	: 21/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade que registra a instrução a ser executada, modulando 
-- corretamente a saída de acordo com o layout padrão das intruções do Mips.
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 
-- Revision Number	: 
-- Version			: 
-- Date				: 29/07/2008 
-- Modifier			: João Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Os sinais de entrada e saída e internos passam a ser do 
-- tipo std_logic. 
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


-- Short name: ir
ENTITY Instr_Reg IS
	PORT( 
		Clk			: IN  STD_LOGIC;					 -- Clock do sistema
		Reset		: IN  STD_LOGIC;					 -- Reset
		Load_ir		: IN  STD_LOGIC;					 -- Bit para ativar carga do registrador de intruções
		Entrada		: IN  STD_LOGIC_VECTOR(31 DOWNTO 0); -- Intrução a ser carregada
		Instr31_26	: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);	 -- Bits 31 a 26 da instrução
		Instr25_21	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);	 -- Bits 25 a 21 da instrução
		Instr20_16	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);	 -- Bits 20 a 16 da instrução
		Instr15_0	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)	 -- Bits 15 a 0 da instrução
	);
END Instr_Reg;


ARCHITECTURE behavioral_arch OF Instr_Reg IS

	
	BEGIN
	
	PROCESS(clk, reset)

		BEGIN
			
			IF( reset = '1' )THEN
			
				Instr31_26 <= (OTHERS => '0');  
				Instr25_21 <= (OTHERS => '0');  
				Instr20_16 <= (OTHERS => '0');  
				Instr15_0  <= (OTHERS => '0');
				
			ELSIF( clk = '1' and clk'event )THEN
			
				IF( load_ir = '1' )THEN
	
					Instr31_26 <= entrada(31 DOWNTO 26); -- Modula instrução (31 a 26)  
					Instr25_21 <= entrada(25 DOWNTO 21); -- Modula instrução (25 a 21)  
					Instr20_16 <= entrada(20 DOWNTO 16); -- Modula instrução (20 a 16)  
					Instr15_0  <= entrada(15 DOWNTO 0);  -- Modula instrução (15 a 0)  
				
				END IF;
			
			END IF;
	
	END PROCESS;
 
END behavioral_arch; 
