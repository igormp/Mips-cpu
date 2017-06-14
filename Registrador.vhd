--------------------------------------------------------------------------------
-- Title		: Registrador de Uso Geral
-- Project		: CPU Multi-ciclo
--------------------------------------------------------------------------------
-- File			: Registrador.vhd
-- Author		: Emannuel Gomes Macêdo (egm@cin.ufpe.br)
--				  Fernando Raposo Camara da Silva (frcs@cin.ufpe.br)
--				  Pedro Machado Manhães de Castro (pmmc@cin.ufpe.br)
--				  Rodrigo Alves Costa (rac2@cin.ufpe.br)
-- Organization : Universidade Federal de Pernambuco
-- Created		: 11/07/2002
-- Last update	: 21/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade que representa a unidade básica de uma cpu ou um
-- circuito que armazena dados na forma de bits.
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 1
-- Revision Number	: 1.0
-- Version			: 1.1
-- Date				: 21/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado (mvlm@cin.ufpe.br)
--				  	  Paulo Roberto Santana Oliveira Filho (prsof@cin.ufpe.br)
--					  Viviane Cristina Oliveira Aureliano (vcoa@cin.ufpe.br)
-- Description		:
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Revisions		: 2
-- Revision Number	: 1.1
-- Version			: 1.2
-- Date				: 08/08/2008
-- Modifier			: João Paulo Fernandes Barbosa (jpfb@cin.ufpe.br)
-- Description		: Os sinais de entrada e saída passam a ser do tipo std_logic.
--------------------------------------------------------------------------------



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

--Short name: reg
ENTITY Registrador IS
		PORT(
			Clk		: IN  STD_LOGIC;						-- Clock do registrador
			Reset	: IN  STD_LOGIC;						-- Reinicializa o conteudo do registrador
			Load	: IN  STD_LOGIC;						-- Carrega o registrador com o vetor Entrada
			Entrada : IN  STD_LOGIC_vector (31 downto 0); 	-- Vetor de bits que possui a informação a ser carregada no registrador
			Saida	: OUT STD_LOGIC_vector (31 downto 0)	-- Vetor de bits que possui a informação já carregada no registrador
		);
END Registrador;

-- Arquitetura que define comportamento do Registrador
-- Simulation
ARCHITECTURE behavioral_arch OF Registrador IS
	begin
-- Clocked process	
	process (Clk, Reset)
		begin
------------------------------------------- Reset inicializa o registrador comum
			if(Reset = '1') then
				Saida <= "00000000000000000000000000000000";

------------------------------------------- Início do processo relacionado ao clock 
			elsif (Clk = '1' and clk'event) then
				if (Load = '1') then
					Saida <= Entrada;
				end if;
			end if;
------------------------------------------- Fim do processo relacionado ao clock
 	end process;
------------------------------------------- Fim da Arquitetura
END behavioral_arch;


