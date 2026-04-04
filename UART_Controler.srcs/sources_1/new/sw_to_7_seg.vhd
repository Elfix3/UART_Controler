----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2026 18:17:16
-- Design Name: 
-- Module Name: sw_to_7_seg - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sw_to_7_seg is
    Port (
        values : in std_logic_vector(15 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        
        
        seg : out std_logic_vector(6 downto 0);      
        an : out std_logic_vector(3 downto 0)
        
    );
end sw_to_7_seg;

architecture Behavioral of sw_to_7_seg is

    signal refreshCount : unsigned(19 downto 0) := (others => '0'); --count for 2.6 ms refresh period for on digit
    signal digitSel : std_logic_vector(1 downto 0) := "00"; --used to select the digit to power

    signal digitToDisplay : std_logic_vector(3 downto 0) := "0000";

    begin

        process(clk,rst) begin
            if (rst = '1') then
                refreshCount <= (others => '0');
                elsif rising_edge(clk) then
                    refreshCount <= refreshCount+1;
                end if;
        end process;
        
        
        
        
        process(clk, rst) begin
            if rst = '1' then
                digitSel <= "00";
            elsif rising_edge(clk) then
                digitSel <= std_logic_vector(refreshCount(19 downto 18));
            end if;
        end process;
                
        with digitSel select an <= "1110" when "00",
        "1101" when "01",
        "1011" when "10",
        "0111" when others;
        
        with digitSel select digitToDisplay <=  values(3 downto 0)when "00",
        values(7 downto 4) when "01",
        values(11 downto 8) when "10",
        values(15 downto 12) when others;
        
        with digitToDisplay select seg <=
        "0000001" when "0000", -- 0
        "1001111" when "0001", -- 1
        "0010010" when "0010", -- 2
        "0000110" when "0011", -- 3
        "1001100" when "0100", -- 4
        "0100100" when "0101", -- 5
        "0100000" when "0110", -- 6
        "0001111" when "0111", -- 7
        "0000000" when "1000", -- 8
        "0000100" when "1001", -- 9
        "0001000" when "1010", -- A
        "1100000" when "1011", -- b
        "0110001" when "1100", -- C
        "1000010" when "1101", -- d
        "0110000" when "1110", -- E
        "0111000" when "1111", -- F
        "1111111" when others; -- éteint
        

end Behavioral;
