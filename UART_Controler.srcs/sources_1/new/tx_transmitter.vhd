----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2026 21:46:07
-- Design Name: 
-- Module Name: tx_transmitter - Behavioral
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

entity tx_transmitter is
    Port(
        byte : in std_logic_vector(7 downto 0);
        clk : in std_logic;
        tick_9600 : in std_logic;
        send_byte_signal : in std_logic; --previously send_button
        
        
        tx_line : out std_logic := '1';
        
        tx_done : out std_logic := '0' --txdone garbage
        
    );
end tx_transmitter;

architecture Behavioral of tx_transmitter is
    signal full_data : std_logic_vector(10 downto 0);
    
    
    
    --signal count : unsigned(9 downto 0) := "0000000000"; -- with 9600 clk period, approx 50 ms of debounce with the MSB acting as a trigger
    
    signal previous_send_button : std_logic := '0';
    signal stable_send_button : std_logic := '0';
    
begin
    
    
    full_data <= '1' & (xor byte) & byte  & '0';    
      

         process(clk)
            variable bitPos : integer range 0 to 11 := 0;
            --variable transmissionInProcess : std_logic := '0';
            variable prev_send_byte_signal : std_logic := '0';
            --should have a flag to finish transmision even if button is released during the thang
         begin
            if rising_edge(clk) then --should be rising edge of master clock             
           
                 if tick_9600 = '1' then --and tick
                        --if (send_signal = '1' and prev_send_signal = '0' and bitPos = 0) or (bitPos <= 10 and bitPos > 0) and (transmissionInProcess = '0') then --start bit
                         if(send_byte_signal = '1' and prev_send_byte_signal = '0' and bitPos = 0) or (bitPos > 0 and bitPos <= 10) then
                            tx_line <= full_data(bitPos);
                            bitPos := bitPos + 1;
                         elsif( bitPos = 11) then
                            tx_line <= '1';
                            bitPos := 0;
                         end if;
                     prev_send_byte_signal := send_byte_signal;
                 end if;

                 
            end if;
        end process;
    
    
end Behavioral;
