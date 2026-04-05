----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2026 09:56:58
-- Design Name: 
-- Module Name: top - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity top is
    Port(
        sw : in std_logic_vector(7 downto 0);      --switches 
        clk : in std_logic;                         --master clock
        btnC : in std_logic;                        --buttonCenter
        btnR : in std_logic;                        --buttonRight
        btnU : in std_logic;                        --buttonRight


        rx_line : in std_logic;                     --reception line
        tx_line : out std_logic;                    --transmission line
        
        seg : out std_logic_vector (6 downto 0);    --7 segments cathodes
        an : out std_logic_vector(3 downto 0);       --7 segments common anodes
        led : out std_logic
        --led_send : out std_logic;
        
        
    );
end top;

architecture Behavioral of top is
    
    --synchroniyzed ticks
    signal tick_9600 : std_logic;

    --recieved and data to send
    signal recievedByte : std_logic_vector(7 downto 0) := "00000000";
    signal byteToSend : std_logic_vector(7 downto 0);
    
    
    --binari values of the 7 seg displayer
    signal values : std_logic_vector(15 downto 0) := (others => '0');
    

    --clean buttonOutputs, produced by the debouncer
    signal clean_Buttons : std_logic_vector(2 downto 0);
    signal clean_btnR : std_logic := '0';
    signal clean_btnC : std_logic := '0';
    signal clean_btnU : std_logic := '0';


    -- Memory settings
    constant ROM_SIZE : integer := 4096;
    signal address : std_logic_vector(11 downto 0) := (others => '0');
    
    
    
    --whatever go my counter
    signal counter : integer := 0;
    
    --states
    type t_state is(IDLE, SEND_BYTE, DELAY,  MEMORY_INCREMENT);
    signal current_state : t_state := IDLE;
    
    
    signal tx_done : std_logic := '0';
   
    signal send_byte_signal : std_logic := '0';
    begin
        
        values <= recievedByte & sw;
        
        clean_btnC <= clean_buttons(2);
        clean_btnR <= clean_buttons(1);
        clean_btnU <= clean_buttons(0);
        
        BUTTONS_DBOUNCER : entity work.debouncer generic map(n => 3)
        port map(
            raw => btnC & btnR & btnU,
            clk => clk,
            clean => clean_Buttons
        );
        
        CLK_DIVIDER : entity work.clock_divider port map(
            input_clock => clk,
            enable => '1',
            output_tick => tick_9600
        );
        
        SW_TO_7_SEG : entity work.sw_to_7_seg port map(
           values => values,
           clk => clk,
           rst => btnC,
           seg => seg,
           an => an
        );
        
        TX : entity work.tx_transmitter port map(
            byte => byteToSend,
            clk => clk,
            tick_9600 => tick_9600,
            send_byte_signal => send_byte_signal,
            tx_line => tx_line    
        );
        
        RX : entity work.rx_reciever port map(
            rx_line => rx_line,
            clk => clk,
            tick_9600 => tick_9600,            
            byte => recievedByte,
            parity => led
        );
        
        ROM : entity work.blk_mem_gen_0 port map(
            clka => clk,
            ena => '1',
            addra => address,
            douta => byteToSend
        );
        
        
        process(clk)
            variable memIndex : integer := 0;
            variable memStop : integer := 0;
        begin
           if rising_edge(clk) then
                if tick_9600 = '1' then
                    case current_state is
                        when IDLE =>
                            send_byte_signal <= '0';
                            if clean_btnR = '1' then
                                current_state <= SEND_BYTE;
                                memIndex := 0;
                                memStop := 16;
                            end if;
                            
                            if clean_btnC = '1' then
                                current_state <= SEND_BYTE;
                                memIndex := 16;
                                memStop := 35;
                            end if;
                            
                            if clean_btnU = '1' then
                                current_state <= SEND_BYTE;
                                memIndex :=35;
                                memStop := 90;
                            end if;
                        
                        when SEND_BYTE =>
                            send_byte_signal <= '1';
                            current_state <= DELAY;
                        
                        when DELAY =>
                            if send_byte_signal = '1' then
                                address <= std_logic_vector(to_unsigned(memIndex,12));
                                memIndex := memIndex +1;
                                send_byte_signal <= '0';
                            end if;
                            
                            if(counter < 96) then
                                counter <= counter + 1; 
                 
                            elsif counter = 96 then
                                counter <= 0;
                                if memIndex < memStop then
                                    current_state <= SEND_BYTE;
                                else 
                                    memIndex := 0;
                                    current_state <= IDLE;
                                end if;
                            end if;
                            
                        when others =>
                    end case;
                    
                    
                                        
                end if;
           end if;
        end process;
        
        
        

end Behavioral;
