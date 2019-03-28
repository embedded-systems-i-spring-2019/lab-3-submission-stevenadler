library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debounce is

    port(
        clk     : in  std_logic;  
        btn  	: in  std_logic;  
        dbnc 	: out std_logic   
    ); 
    
end debounce;

architecture behavior of debounce is
    
    signal shift_reg   : std_logic_vector(1 downto 0);                  
    signal counter : std_logic_vector(21 downto 0) := (others => '0'); 
    signal counter_size : std_logic_vector(21 downto 0) := "1001100010010110100000"; -- 2500000 in binary
begin
    process(clk)
    begin
        if rising_edge(clk) then
            shift_reg(0) <= btn;
            shift_reg(1) <= shift_reg(0);
            if(counter = counter_size) then 
                dbnc <= '1';
            elsif(shift_reg(1) = '1') then                  
                counter <= std_logic_vector(unsigned(counter) + 1);
                dbnc <= '0';
            end if;
            if(shift_reg(1) = '0') then                                      
                counter <= "0000000000000000000000";
                dbnc <= '0';
            end if;    
        end if;
    end process;
end behavior;