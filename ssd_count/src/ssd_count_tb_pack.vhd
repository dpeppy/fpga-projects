package ssd_count_tb_pack is

  constant C_CLK_FREQ_MHZ  : NATURAL := 125;  -- 125 MHz
  constant C_DEB_TIME_MS   : NATURAL := 1;    -- 1 ms
  constant C_SSD_COM_ANODE : BOOLEAN := TRUE;

  function to_string(inp : BIT_VECTOR) return STRING;

  procedure chk_seg(exp          : in NATURAL range 0 to 15;
                    signal seg   : in BIT_VECTOR(0 to 6);
                    signal clock : in BIT);

  procedure gen_clock(period       : in    TIME;
                      enable       : in    BOOLEAN;
                      signal clock : inout BIT);

  procedure gen_reset(num_clocks   : in  NATURAL;
                      active_high  : in  BOOLEAN;
                      signal clock : in  BIT;
                      signal reset : out BIT);

  procedure gen_pulse(high_cycles   : in  NATURAL;
                      high_rand     : in  BOOLEAN;
                      low_cycles    : in  NATURAL;
                      low_rand      : in  BOOLEAN;
                      signal clock  : in  BIT;
                      signal output : out BIT);

  procedure print(msg : in STRING);

end package;

library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

library ssd_count;
use ssd_count.ssd_count_pack.all;

package body ssd_count_tb_pack is

  function to_string(inp : BIT_VECTOR) return STRING is
    variable str : STRING(1 to inp'length);
    variable tmp : BIT_VECTOR(1 to inp'length) := inp;
  begin
    for i in str'range loop
      case tmp(i) is
        when '0' => str(i) := '0';
        when '1' => str(i) := '1';
      end case;
    end loop;
    return(str);
  end;

  procedure chk_seg(exp          : in NATURAL range 0 to 15;
                    signal seg   : in BIT_VECTOR(0 to 6);
                    signal clock : in BIT) is
  begin
    wait until clock'event and clock = '1';
    assert (to_seg(C_SSD_COM_ANODE, exp) = seg)
      report "chk_output: exp = " & to_string(to_seg(C_SSD_COM_ANODE, exp)) & ", got = " & to_string(seg)
      severity ERROR;
  end;

  procedure gen_clock(period       : in    TIME;
                      enable       : in    BOOLEAN;
                      signal clock : inout BIT) is
  begin
    if (enable) then
      if (clock = '1') then
        clock <= '0' after period/2;
      else
        clock <= '1' after period-period/2;  -- Factor in odd periods
      end if;
    end if;
  end;

  procedure gen_reset(num_clocks   : in  NATURAL;
                      active_high  : in  BOOLEAN;
                      signal clock : in  BIT;
                      signal reset : out BIT) is
  begin
    print("gen_reset: num_clocks = " & integer'image(num_clocks));
    -- Assert reset
    if (active_high) then
      reset <= '1';
    else
      reset <= '0';
    end if;
    -- Wait specified clocks
    for i in 0 to num_clocks-1 loop
      wait until clock'event and clock = '1';
    end loop;
    -- De-assert reset
    if (active_high) then
      reset <= '0';
    else
      reset <= '1';
    end if;
  end;

  procedure gen_pulse(high_cycles   : in  NATURAL;
                      high_rand     : in  BOOLEAN;
                      low_cycles    : in  NATURAL;
                      low_rand      : in  BOOLEAN;
                      signal clock  : in  BIT;
                      signal output : out BIT) is
    variable count : NATURAL;
    variable rand  : REAL;
    variable seed1 : POSITIVE;
    variable seed2 : POSITIVE;
  begin

    print("gen_pulse: high_cycles = " & integer'image(high_cycles) &
          ", rand_high = "  & boolean'image(high_rand) &
          ", low_cycles = " & integer'image(low_cycles) &
          ", low_rand = "   & boolean'image(low_rand));

    -- Pulse high time
    count := 0;
    for i in 0 to high_cycles-1 loop
      wait until clock'event and clock = '1';
      -- Randomize 10% of high cycles
      if (high_rand and (count < high_cycles/10)) then
        if (count mod 1000 = 0) then
          uniform(seed1, seed2, rand);
          output <= to_bit(to_unsigned(natural(round(rand)), 1)(0));
        end if;
      else
        output <= '1';
      end if;
      count := count + 1;
    end loop;

    -- Pulse low time
    count := 0;
    for i in 0 to low_cycles-1 loop
      wait until clock'event and clock = '1';
      -- Randomize 10% of low cycles
      if (low_rand and (count < low_cycles/10)) then
        if (count mod 1000 = 0) then
          uniform(seed1, seed2, rand);
          output <= to_bit(to_unsigned(natural(round(rand)), 1)(0));
        end if;
      else
        output <= '0';
      end if;
      count := count + 1;
    end loop;

  end;

  procedure print(msg : in STRING) is
    variable l : line;
  begin
    write(l, msg);
    writeline(output, l);
  end;

end package body;
