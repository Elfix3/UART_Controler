----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2026 15:15:13
-- Design Name: 
-- Module Name: clock_divider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
    Port (
        
        input_clock : in std_logic;
        enable : in std_logic;
        output_tick : out std_logic := '0'
        
    );
end clock_divider;

architecture Behavioral of clock_divider is
    constant max_count : integer := 10416; --Ticks at 9600 Hz
    signal counter : integer := 0;
    
    --signal clk_int : std_logic := '0';

begin
     process(input_clock)begin
        if rising_edge(input_clock) then
            output_tick <= '0';
            if enable = '1' then
                if counter = max_count then
                    output_tick <= '1';
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
            end if;
        end if;
    end process;
    

    
    
    
    
end Behavioral;
