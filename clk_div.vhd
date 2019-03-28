library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_div is
port (
  clk : in std_logic;
  div : out std_logic
);
end clk_div;

architecture Behavioral of clk_div is
  --11 bits to count to 1085 (125MHz/115.2hz = 1085.07)
  signal count : std_logic_vector (10 downto 0) := (others => '0');
begin
  
  process(clk) begin
    if rising_edge(clk) then
        if(unsigned(count) < 1085) then
        div <= '0';
      count <= std_logic_vector( unsigned(count) + 1 );
        else
        count <= (others => '0');
        div <= '1';
        end if;
    end if;
  end process;
end Behavioral;