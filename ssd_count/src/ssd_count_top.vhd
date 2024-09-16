entity ssd_count_top is
  generic (
    CLOCK_FREQ_HZ  : NATURAL := 125*1e6; -- Clock frequency
    STABLE_TIME_MS : NATURAL := 10       -- Debounce stable time
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
end entity;

architecture one_seg of ssd_count_top is

  signal input_reg : bit_vector(0 to 5);

  signal deb_count : NATURAL range 0 to CLOCK_FREQ_HZ*STABLE_TIME_MS/1000;
  signal ssd_count : NATURAL range 0 to 15;

begin

  -- Segment defaults
  ssd_seg1 <= (others => '0');
  ssd_sel  <= '0';

  SEVEN_SEG_COUNT : process (clock, reset) is
  begin

    if (reset = '1') then

      input_reg <= (others => '0');
      ssd_seg0  <= (others => '0');

      deb_count <= 0;
      ssd_count <= 0;

    elsif (clock'event and clock = '1') then

      -- Input registers
      input_reg(0 to 3) <= button & input_reg(0 to 2);

      -- Debounce logic
      if (input_reg(2) /= input_reg(3)) then
        deb_count <= 0;
      elsif (deb_count < CLOCK_FREQ_HZ*STABLE_TIME_MS/1000) then
        deb_count <= deb_count + 1;
      else
        input_reg(4 to 5) <= input_reg(3 to 4);
      end if;

      -- SSD counter logic
      if (input_reg(4) = '1' and input_reg(5) = '0') then
        if (ssd_count < 15) then
          ssd_count <= ssd_count + 1;
        else
          ssd_count <= 0;
        end if;
      end if;

      -- SSD decoder
      case ssd_count is
        when 0  => ssd_seg0 <= "1111110";
        when 1  => ssd_seg0 <= "0110000";
        when 2  => ssd_seg0 <= "1101101";
        when 3  => ssd_seg0 <= "1111001";
        when 4  => ssd_seg0 <= "0110011";
        when 5  => ssd_seg0 <= "1011011";
        when 6  => ssd_seg0 <= "0011111";
        when 7  => ssd_seg0 <= "1110000";
        when 8  => ssd_seg0 <= "1111111";
        when 9  => ssd_seg0 <= "1110011";
        when 10 => ssd_seg0 <= "1110111";
        when 11 => ssd_seg0 <= "0011111";
        when 12 => ssd_seg0 <= "1001110";
        when 13 => ssd_seg0 <= "0111101";
        when 14 => ssd_seg0 <= "1001111";
        when 15 => ssd_seg0 <= "1000111";
      end case;

    end if;

  end process;

end architecture one_seg;

configuration ssd_config of ssd_count_top is
  for one_seg
  end for;
end configuration ssd_config;
