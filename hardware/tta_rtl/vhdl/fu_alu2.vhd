-- Module generated by TTA Codesign Environment
-- 
-- Generated on Mon Jul 20 09:52:14 2020
-- 
-- Function Unit: ALU2
-- 
-- Operations:
--  add : 0
--  eq  : 1
--  gt  : 2
--  gtu : 3
--  ne  : 4
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity fu_alu2 is
  port (
    clk : in std_logic;
    rstx : in std_logic;
    glock_in : in std_logic;
    glockreq_out : out std_logic;
    operation_in : in std_logic_vector(3-1 downto 0);
    data_P1_in : in std_logic_vector(32-1 downto 0);
    load_P1_in : in std_logic;
    data_P2_in : in std_logic_vector(32-1 downto 0);
    load_P2_in : in std_logic;
    data_P3_out : out std_logic_vector(32-1 downto 0));
end entity fu_alu2;

architecture rtl of fu_alu2 is

  constant op_add_c : std_logic_vector(2 downto 0) := "000";
  constant op_eq_c : std_logic_vector(2 downto 0) := "001";
  constant op_gt_c : std_logic_vector(2 downto 0) := "010";
  constant op_gtu_c : std_logic_vector(2 downto 0) := "011";
  constant op_ne_c : std_logic_vector(2 downto 0) := "100";

  signal add_op1 : std_logic_vector(31 downto 0);
  signal add_op2 : std_logic_vector(31 downto 0);
  signal add_op3 : std_logic_vector(31 downto 0);
  signal eq_op1 : std_logic_vector(31 downto 0);
  signal eq_op2 : std_logic_vector(31 downto 0);
  signal eq_op3 : std_logic;
  signal gt_op1 : std_logic_vector(31 downto 0);
  signal gt_op2 : std_logic_vector(31 downto 0);
  signal gt_op3 : std_logic;
  signal gtu_op1 : std_logic_vector(31 downto 0);
  signal gtu_op2 : std_logic_vector(31 downto 0);
  signal gtu_op3 : std_logic;
  signal ne_op1 : std_logic_vector(31 downto 0);
  signal ne_op2 : std_logic_vector(31 downto 0);
  signal ne_op3 : std_logic;
  signal data_P1 : std_logic_vector(31 downto 0);
  signal data_P2 : std_logic_vector(31 downto 0);
  signal data_P3 : std_logic_vector(31 downto 0);

  signal shadow_P2_r : std_logic_vector(31 downto 0);
  signal operation_1_r : std_logic_vector(2 downto 0);
  signal optrig_1_r : std_logic;
  signal data_P3_1_r : std_logic_vector(31 downto 0);
  signal data_P3_1_valid_r : std_logic;
  signal data_P3_r : std_logic_vector(31 downto 0);

begin

  data_P1 <= data_P1_in;

  shadow_P2_sp : process(clk, rstx)
  begin
    if rstx = '0' then
      shadow_P2_r <= (others => '0');
    elsif clk = '1' and clk'event then
      if ((glock_in = '0') and (load_P2_in = '1')) then
        shadow_P2_r <= data_P2_in;
      end if;
    end if;
  end process shadow_P2_sp;

  shadow_P2_cp : process(shadow_P2_r, data_P2_in, load_P1_in, load_P2_in)
  begin
    if ((load_P1_in = '1') and (load_P2_in = '1')) then
      data_P2 <= data_P2_in;
    else
      data_P2 <= shadow_P2_r;
    end if;
  end process shadow_P2_cp;

  input_pipeline_sp : process(clk, rstx)
  begin
    if rstx = '0' then
      operation_1_r <= (others => '0');
      optrig_1_r <= '0';
    elsif clk = '1' and clk'event then
      if (glock_in = '0') then
        optrig_1_r <= load_P1_in;
        if (load_P1_in = '1') then
          operation_1_r <= operation_in;
        end if;
      end if;
    end if;
  end process input_pipeline_sp;

  operations_actual_cp : process(operation_in, load_P1_in, gt_op2, ne_op2, eq_op2, ne_op1, data_P1, gt_op1, gtu_op1, gtu_op2, data_P2, add_op1, eq_op1, add_op2)
  begin
    ne_op3 <= '-';
    ne_op1 <= data_P2;
    ne_op2 <= data_P1;
    gtu_op3 <= '-';
    gtu_op1 <= data_P2;
    gtu_op2 <= data_P1;
    add_op3 <= (others => '-');
    add_op1 <= data_P1;
    add_op2 <= data_P2;
    gt_op3 <= '-';
    gt_op1 <= data_P2;
    gt_op2 <= data_P1;
    eq_op3 <= '-';
    eq_op1 <= data_P2;
    eq_op2 <= data_P1;
    if (load_P1_in = '1') then
      case operation_in is
        when op_add_c =>
          add_op3 <= std_logic_vector(signed(add_op1) + signed(add_op2));
        when op_eq_c =>
          if eq_op1 = eq_op2 then
            eq_op3 <= '1';
          else
            eq_op3 <= '0';
          end if;
        when op_gt_c =>
          if signed(gt_op1) > signed(gt_op2) then
            gt_op3 <= '1';
          else
            gt_op3 <= '0';
          end if;
        when op_gtu_c =>
          if unsigned(gtu_op1) > unsigned(gtu_op2) then
            gtu_op3 <= '1';
          else
            gtu_op3 <= '0';
          end if;
        when op_ne_c =>
          if ne_op1 /= ne_op2 then
            ne_op3 <= '1';
          else
            ne_op3 <= '0';
          end if;
        when others =>
      end case;
    end if;
  end process operations_actual_cp;

  output_pipeline_sp : process(clk, rstx)
  begin
    if rstx = '0' then
      data_P3_r <= (others => '0');
      data_P3_1_valid_r <= '0';
      data_P3_1_r <= (others => '0');
    elsif clk = '1' and clk'event then
      if (glock_in = '0') then
        data_P3_1_valid_r <= '1';
        if ((operation_in = op_ne_c) and (load_P1_in = '1')) then
          data_P3_1_r <= ((32-1 downto 1 => '0') & ne_op3);
        elsif ((operation_in = op_gtu_c) and (load_P1_in = '1')) then
          data_P3_1_r <= ((32-1 downto 1 => '0') & gtu_op3);
        elsif ((operation_in = op_gt_c) and (load_P1_in = '1')) then
          data_P3_1_r <= ((32-1 downto 1 => '0') & gt_op3);
        elsif ((operation_in = op_eq_c) and (load_P1_in = '1')) then
          data_P3_1_r <= ((32-1 downto 1 => '0') & eq_op3);
        elsif ((operation_in = op_add_c) and (load_P1_in = '1')) then
          data_P3_1_r <= add_op3;
        else
          data_P3_1_valid_r <= '0';
        end if;
        data_P3_r <= data_P3;
      end if;
    end if;
  end process output_pipeline_sp;

  output_pipeline_cp : process(data_P3, data_P3_1_r)
  begin
    data_P3 <= data_P3_1_r;
    data_P3_out <= data_P3;
  end process output_pipeline_cp;
  glockreq_out <= '0';

end architecture rtl;

