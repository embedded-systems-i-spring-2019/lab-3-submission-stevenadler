library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sender_top is
  Port (TXD, clk : in std_logic;
        btn : in std_logic_vector(1 downto 0);
        CTS, RTS, RXD : out std_logic);
end sender_top;

architecture Behavioral of sender_top is

component uart 
    port(
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;

component debounce 
        Port (clk: in std_logic;
        btn: in std_logic;
        dbnc: out std_logic);
end component;

component clk_div
    port (
    clk : in std_logic;
    div : out std_logic);
end component;

component sender
  Port ( rst, clk, en, btn, ready: in std_logic;
         send : out std_logic;
         char : out std_logic_vector(7 downto 0));
end component;

signal u1_out, u2_out, u3_out, u4_send, u5_ready : std_logic;
signal u4_char : std_logic_vector(7 downto 0);

begin

RTS <= '0';
CTS <= '0';

u1: debounce port map(btn => btn(0),
                      clk => clk,
                      dbnc => u1_out);
                      
u2: debounce port map(btn => btn(1),
                      clk => clk,
                      dbnc => u2_out);
                      
u3: clk_div port map(clk => clk,
                     div => u3_out);
                     
u4: sender port map(btn => u2_out,
                    clk => clk,
                    en => u3_out,
                    ready => u5_ready,
                    rst => u1_out,
                    char => u4_char,
                    send => u4_send);
                    
u5: uart port map(charSend => u4_char,
                  clk => clk,
                  en => u3_out,
                  rst => u1_out,
                  rx => TXD,
                  send => u4_send,
                  ready => u5_ready,
                  tx => RXD);


end Behavioral;