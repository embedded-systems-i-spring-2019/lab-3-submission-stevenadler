library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
  port ( 
    clk, en, send, rst : in std_logic;
    char : in std_logic_vector(7 downto 0);
    ready, tx : out std_logic
);
end uart_tx;

architecture fsm of uart_tx is

    type state is (idle, start, data);
    signal curr : state := idle;
    signal D : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk)
    variable count : integer range 0 to 8;
    begin
    if(rising_edge(clk)) then
    
        if(rst = '1') then
            D <= (others => '0');
            ready <= '1';
            tx <= '1';
            count := 0;
            curr <= idle;
        elsif(en = '1') then
        case curr is
            when idle =>
                ready <= '1';
                tx <= '1';
                 count := 0;
                if(send = '1') then
                    D <= char;
                    curr <= start;
                    ready <= '0';
                else
                    curr <= idle;
                end if;
            when start =>
                ready <= '0';
                tx <= '0';
                curr <= data;
            when data =>
                if(count < 8) then
                    tx <= D(count);
                    count := count + 1;
                else
                    tx <= '1'; 
                    curr <= idle; 
                      
                end if;
            when others => curr <= idle;
         end case;
         end if;
     end if;
   end process;
                   
end fsm;