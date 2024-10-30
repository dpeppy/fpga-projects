entity tb is
end entity tb;

library ssd_count;
use ssd_count.ssd_count_pack.all;

library ssd_count_tb;
use ssd_count_tb.ssd_count_tb_pack.all;

architecture behav of tb is

  constant C_PULSE_CLOCKS : natural := C_CLK_FREQ_MHZ*2*C_DEB_TIME_MS*(1e6/1000);

  -- Clock/Reset Signals
  signal clock_125 : BIT;
  signal reset     : BIT;

  -- DUT Signals
  signal button  : BIT;
  signal ssd_seg : BIT_VECTOR(0 to 6);
  signal ssd_sel : BIT;

begin

  TEST : process is
  begin

    -- DUT reset
    gen_reset(10, true, clock_125, reset);

    for i in 0 to 31 loop
      -- Simulate button presses
      gen_pulse(C_PULSE_CLOCKS, true, C_PULSE_CLOCKS, false, clock_125, button);
      -- Check segment values
      if (ssd_sel = '0') then
        chk_seg((i+1) mod 16, ssd_seg, clock_125);
      else
        chk_seg((i+1)/16, ssd_seg, clock_125);
      end if;
    end loop;

    -- Stop test
    assert false report "Test complete" severity failure;

  end process;

  -- Clock Generator
  gen_clock(8 ns, true, clock_125);

  -- Design Under Test
  DUT : entity ssd_count.ssd_count_top(one_seg)
    generic map (
      CLK_FREQ_MHZ  => C_CLK_FREQ_MHZ,
      DEB_TIME_MS   => C_DEB_TIME_MS,
      SSD_COM_ANODE => C_SSD_COM_ANODE
      )
    port map (
      -- Clock/Reset Interface
      clock   => clock_125,
      reset   => reset,
      -- Button Input
      button  => button,
      -- Seven Segment Interface
      ssd_seg => ssd_seg,
      ssd_sel => ssd_sel
      );

end architecture behav;
