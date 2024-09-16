entity tb is
end entity tb;

library ssd_count;

library ssd_count_tb;
use ssd_count_tb.ssd_count_tb_pack.all;

architecture behav of tb is

  -- Constants
  constant C_CLOCK_FREQ_HZ  : NATURAL := 125*1e6;  -- 125 MHz
  constant C_STABLE_TIME_MS : NATURAL := 1;        -- 1 ms

  -- Clock/Reset Signals
  signal clock_125 : BIT;
  signal reset     : BIT;

  -- DUT Signals
  signal button   : BIT;
  signal ssd_seg0 : BIT_VECTOR(0 to 6);
  signal ssd_seg1 : BIT_VECTOR(0 to 6);  
  signal ssd_sel  : BIT;

  -- Component Declaration
  component ssd_count_top is
    generic (
      CLOCK_FREQ_HZ  : NATURAL := 125e6;
      STABLE_TIME_MS : NATURAL := 8
      );
    port (
      -- Clock/Reset Interface
      clock    : in  BIT;
      reset    : in  BIT;
      -- Button Input
      button   : in  BIT;
      -- Seven Segment Interface
      ssd_seg0 : out BIT_VECTOR(0 to 6);
      ssd_seg1 : out BIT_VECTOR(0 to 6);
      ssd_sel  : out BIT
      );
  end component;

begin

  TEST : process is
  begin

    -- DUT reset
    gen_reset(10, true, clock_125, reset);

    -- Simulate button presses
    for i in 0 to 15 loop
      gen_pulse(C_CLOCK_FREQ_HZ*2*C_STABLE_TIME_MS/1000, true, C_CLOCK_FREQ_HZ*2*C_STABLE_TIME_MS/1000, false, clock_125, button);
    end loop;

    -- Stop test
    assert false report "Test complete" severity failure;

  end process;

  -- Clock Generator
  gen_clock(8 ns, true, clock_125);

  -- Design Under Test
  DUT : ssd_count_top
    generic map (
      CLOCK_FREQ_HZ  => C_CLOCK_FREQ_HZ,
      STABLE_TIME_MS => C_STABLE_TIME_MS
      )
    port map (
      -- Clock/Reset Interface
      clock    => clock_125,
      reset    => reset,
      -- Button Input
      button   => button,
      -- Seven Segment Interface
      ssd_seg0 => ssd_seg0,
      ssd_seg1 => ssd_Seg1,
      ssd_sel  => ssd_sel
      );

end architecture behav;
