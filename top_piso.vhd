library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_piso is
    Port (
        clk      : in  STD_LOGIC;                    -- Clock 100 MHz (Pin W5)
        rst      : in  STD_LOGIC;                    -- Reset (btnU)
        btn_load : in  STD_LOGIC;                    -- Tombol Load (btnC)
        sw       : in  STD_LOGIC_VECTOR(7 downto 0); -- Input paralel 8-bit
        led0     : out STD_LOGIC                     -- Output serial sout (led(0))
    );
end top_piso;

architecture Behavioral of top_piso is

    -- Sinyal internal untuk synchronizer
    signal sync_load : STD_LOGIC;
    signal ff1, ff2  : STD_LOGIC := '0';

    -- Atribut ASYNC_REG agar Vivado tidak mengoptimasi synchronizer FF
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of ff1 : signal is "TRUE";
    attribute ASYNC_REG of ff2 : signal is "TRUE";

begin

    -- 1. Synchronizer 2-Stage untuk tombol load (mencegah metastabilitas)
    process(clk)
    begin
        if rising_edge(clk) then
            ff1 <= btn_load;
            ff2 <= ff1;
        end if;
    end process;
    sync_load <= ff2;

    -- 2. Instansiasi Shift Register PISO 8-Bit
    u_piso: entity work.piso_8bit
        port map (
            clk  => clk,
            rst  => rst,
            load => sync_load,
            d    => sw,
            sout => led0
        );

end Behavioral;