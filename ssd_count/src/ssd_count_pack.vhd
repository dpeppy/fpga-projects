package ssd_count_pack is

  function to_seg(com_anode : BOOLEAN; inp : NATURAL range 0 to 15) return BIT_VECTOR;

end package ssd_count_pack;

package body ssd_count_pack is

  function to_seg(com_anode : BOOLEAN; inp : NATURAL range 0 to 15) return BIT_VECTOR is
    variable seg : BIT_VECTOR(0 to 6);
  begin
    case inp is
      when 0  => seg := "1111110";
      when 1  => seg := "0110000";
      when 2  => seg := "1101101";
      when 3  => seg := "1111001";
      when 4  => seg := "0110011";
      when 5  => seg := "1011011";
      when 6  => seg := "1011111";
      when 7  => seg := "1110000";
      when 8  => seg := "1111111";
      when 9  => seg := "1110011";
      when 10 => seg := "1110111";
      when 11 => seg := "0011111";
      when 12 => seg := "1001110";
      when 13 => seg := "0111101";
      when 14 => seg := "1001111";
      when 15 => seg := "1000111";
    end case;
    if (com_anode) then
      return(seg);
    else
      return(not seg);
    end if;
  end;

end package body ssd_count_pack;
