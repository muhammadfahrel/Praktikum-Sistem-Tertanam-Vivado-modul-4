library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_piso_8bit is
-- Testbench tidak memiliki port I/O
end tb_piso_8bit;

architecture Behavioral of tb_piso_8bit is

    -- Komponen yang akan diuji
    component piso_8bit
        Port (
            clk  : in  STD_LOGIC;
            rst  : in  STD_LOGIC;
            load : in  STD_LOGIC;
            d    : in  STD_LOGIC_VECTOR(7 downto 0);
            sout : out STD_LOGIC
        );
    end component;

    -- Sinyal simulasi
    signal clk  : STD_LOGIC := '0';
    signal rst  : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal d    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal sout : STD_LOGIC;

    -- Periode Clock (misal 10 ns)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instansiasi Unit Under Test (UUT)
    uut: piso_8bit
        port map (
            clk  => clk,
            rst  => rst,
            load => load,
            d    => d,
            sout => sout
        );

    -- Pembangkit Clock
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proses Stimulus (Skenario Pengujian)
    stim_proc: process
    begin
        -- 1. Inisialisasi & Reset System
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        -- 2. Muat Data Paralel (misal: "10110001" / B1 hex)
        d <= "10110001";
        load <= '1';
        wait for CLK_PERIOD; -- Tahan load selama 1 siklus clock
        
        -- 3. Matikan Load, Biarkan Data Digeser Keluar (Shift Serial)
        load <= '0';
        
        -- Amati output sout pada setiap tepi clock selama 8 siklus clock (80 ns)
        wait for 100 ns;

        -- 4. Uji Muat Data Kedua (misal: "11001110")
        d <= "11001110";
        load <= '1';
        wait for CLK_PERIOD;
        load <= '0';

        wait for 100 ns;
        
        -- Selesai
        wait;
    end process;

end Behavioral;