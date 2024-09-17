entity ssd_count_top is
  generic (
    CLK_FREQ_MHZ  : NATURAL := 125;  -- Clock frequency
    DEB_TIME_MS   : NATURAL := 10;   -- Debounce stable time
    SSD_COM_ANODE : BOOLEAN := TRUE  -- SSD type (true = common anode, false = common cathode)
    );
  port (
    -- Clock/Reset Interface
    clock   : in  BIT;
    reset   : in  BIT;
    -- Button Input
    button  : in  BIT;
    -- Seven Segment Interface
    ssd_seg : out BIT_VECTOR(0 to 6);
    ssd_sel : out BIT
    );
end entity;

library ssd_count;
use ssd_count.ssd_count_pack.all;

architecture one_seg of ssd_count_top is

  constant DEB_COUNT_MAX : NATURAL := CLK_FREQ_MHZ*DEB_TIME_MS*(1e6/1000);
  constant SSD_COUNT_MAX : NATURAL := 15;

  signal deb_count : NATURAL range 0 to DEB_COUNT_MAX;
  signal ssd_count : NATURAL range 0 to SSD_COUNT_MAX;

  signal input_reg : BIT_VECTOR(0 to 5);

begin

  -- SSD defaults
  ssd_sel  <= '0';

  SEVEN_SEG_COUNT : process (clock, reset) is
  begin

    if (reset = '1') then

      deb_count <= 0;
      ssd_count <= 0;

      input_reg <= (others => '0');
      ssd_seg   <= (others => '0');

    elsif (clock'event and clock = '1') then

      -- Input registers
      input_reg(0 to 3) <= button & input_reg(0 to 2);

      -- Debounce logic
      if (input_reg(2) /= input_reg(3)) then
        deb_count <= 0;
      elsif (deb_count < DEB_COUNT_MAX) then
        deb_count <= deb_count + 1;
      else
        input_reg(4 to 5) <= input_reg(3 to 4);
      end if;

      -- SSD counter logic
      if (input_reg(4) = '1' and input_reg(5) = '0') then
        if (ssd_count < SSD_COUNT_MAX) then
          ssd_count <= ssd_count + 1;
        else
          ssd_count <= 0;
        end if;
      end if;

      -- SSD decoder
      ssd_seg <= to_seg(SSD_COM_ANODE, ssd_count);

    end if;

  end process;

end architecture one_seg;

configuration ssd_config of ssd_count_top is
  for one_seg
  end for;
end configuration ssd_config;
