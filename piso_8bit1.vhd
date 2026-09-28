library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso_8bit is
    Port (
        clk  : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        load : in  STD_LOGIC;
        d    : in  STD_LOGIC_VECTOR(7 downto 0);
        sout : out STD_LOGIC
    );
end piso_8bit;

architecture Behavioral of piso_8bit is
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                shift_reg <= (others => '0');
            elsif load = '1' then
                shift_reg <= d;                  -- Parallel load saat load='1'
            else
                shift_reg <= shift_reg(6 downto 0) & '0'; -- Shift left saat load='0'
            end if;
        end if;
    end process;

    sout <= shift_reg(7); -- MSB ke output serial
end Behavioral;