----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2026 16:59:18
-- Design Name: 
-- Module Name: rx_reciever - Behavioral
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

entity rx_reciever is
    Port (
        rx_line : in std_logic;
        clk_9600 : in std_logic;
        byte : out std_logic_vector(7 downto 0) := (others => '0');
        parity : out std_logic
    );

end rx_reciever;


architecture Behavioral of rx_reciever is
    signal full_data : std_logic_vector(10 downto 0) := (others => '0');
    signal recieveInProcess : std_logic := '0';
    signal previous_rx : std_logic := '1';
    
    begin

            
            
            
        process(clk_9600)
        variable bitPos : integer range 0 to 11 := 0;
            begin
                if rising_edge(clk_9600) then
                    if (rx_line = '0' and previous_rx = '1') or (bitPos > 0 and bitPos <= 10) then --falling edge detection
                        recieveInProcess <= '1';
                        full_data(bitPos) <= rx_line;
                        bitPos := bitPos+1;
                    elsif bitPos = 11 then --no parity check at the moment
                        bitPos := 0;
                        byte <= full_data(8 downto 1);
                    end if;
                    previous_rx <= rx_line;   
                end if;
            end process;
            parity <= full_data(9);
        

end Behavioral;
