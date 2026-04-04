----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2026 20:22:48
-- Design Name: 
-- Module Name: tb_sw_to_7seg - Behavioral
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

entity tb is
end tb;

architecture Behavioral of tb is

        signal sw : std_logic_vector(15 downto 0) := (others => '0');
        signal clk : std_logic := '0';
        signal btnC : std_logic := '0';
        signal btnR : std_logic := '0';
        signal recievedByte : std_logic_vector(7 downto 0);
        
        
        signal tx_line : std_logic := '1';
        signal rx_line : std_logic := '1';
        signal tick_9600 : std_logic;
        
    
    begin
    
    clk <= not clk after 5 ns; --10 ns clock
--    TOP : entity work.top port map(
--        sw => sw,
--        clk => clk,
--        btnC => btnC,
--        btnR => btnR,
--        rx_line => '1',
--        tx_line => tx_line
--    );
      
       TX : entity work.tx_transmitter port map(
           byte  => sw(7 downto 0),
           clk => clk,
           tick_9600 => tick_9600,
           send_signal => btnR,
           tx_line => tx_line
       );

--        RX : entity work.rx_reciever port map(
--            rx_line => rx_line,
--            clk_9600 => clk,
--            byte => recievedByte            
--        );    
          T_9600 : entity work.clock_divider port map(
            input_clock => clk,
            enable => '1',
            output_tick => tick_9600
            
          );
    stimuli : process begin
        
        --btnR <= '0';
         
         
         sw(7 downto 0) <= "01001101";  wait for 10 ns;
         btnR <= '1'; wait for 25 ms;
         btnR <= '0'; wait for 25 ms;
         
         sw(7 downto 0) <= "10000001";  wait for 10 ns;
         btnR <= '1'; wait for 25 ms;
         btnR <= '0'; wait for 25 ms;
         
         
--        rx_line <= '0'; wait for 10 ns; --startbit
        
--        rx_line <= '1'; wait for 10 ns;
--        rx_line <= '1'; wait for 10 ns;
--        rx_line <= '1'; wait for 10 ns;
--        rx_line <= '0'; wait for 10 ns;
        
--        rx_line <= '0'; wait for 10 ns;
--        rx_line <= '0'; wait for 10 ns;
--        rx_line <= '1'; wait for 10 ns;
--        rx_line <= '1'; wait for 10 ns;
        
--        rx_line <= '1'; wait for 10 ns; --parity
--        rx_line <= '1'; wait for 10 ns; --stop bit
        
                
        
        
        wait;
    end process;
    
    
    

end Behavioral;
