library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Proyecto is port(
		A: in unsigned(7 downto 0); 
		button_in, button_load,Reset, Clock: in STD_LOGIC;
		cuenta: inout STD_LOGIC_VECTOR(3 DOWNTO 0);
		Z1, Z2: out signed(7 downto 0);
		pulse_out : inout std_logic
);
end Proyecto;

architecture Behavioral of Proyecto is
subtype state is std_logic_vector(3 downto 0);
signal present_state, next_state:state;

signal reg1, reg2, reg3, reg4: signed(7 downto 0):=(others=>'0');
constant comp1:state:="0000";
constant comp2:state:="0001";
constant a_nd:state:="0010";
constant o_r:state:="0011";
constant lsl:state:="0100";
constant lsr:state:="0101";
constant suma8:state:="0110";
constant resta8:state:="0111";
constant division8:state:="1000";

constant COUNT_MAX : integer := 20;
constant BTN_ACTIVE : std_logic := '1';
signal count : integer := 0;
type state_type is (idle,wait_time); --state machine
signal statte : state_type := idle;
signal num1:std_logic_vector(7 downto 0);
signal num2:std_logic_vector(7 downto 0);

begin
reg1<=A;
reg2<=B;
Z1<=reg3;
Z2<=reg4;
process(button_load)
	begin
		if(button_load='1') then
			num1<=
	
process(Reset,Clock)
begin
if(Reset = '1') then
statte <= idle;
pulse_out <= '0';
elsif(rising_edge(Clock)) then
case (statte) is
when idle =>
if(button_in = BTN_ACTIVE) then
statte <= wait_time;
else
statte <= idle; --wait until button is pressed.
end if;
pulse_out <= '0';
when wait_time =>
if(count = COUNT_MAX) then
count <= 0;
if(button_in = BTN_ACTIVE) then
pulse_out <= '1';
end if;
statte <= idle;
else
count <= count + 1;
end if;
end case;
end if;
end process;
	
	
	PROCESS(pulse_out)
	BEGIN
			if (pulse_out='1') then
				if(reset='1') then
					present_state <= comp1;
					else
					present_state <=next_state;
				end if;
			end if;
	end process;
	process(present_state)
			
	begin
		case present_state is
		when comp1=>next_state <=comp1;
		when comp2=>next_state <=a_nd;
		when a_nd=>next_state <=o_r;
		when o_r=>next_state <=lsl;
		when lsl=>next_state <=lsr;
		when lsr=>next_state <=suma8;
		when suma8=>next_state <=resta8;
		when resta8=>next_state <=division8;
		when division8=>next_state <=comp1;
		when others=>next_state <=comp1;
		end case;
		
		cuenta <= present_state;
	end process;
	
	process(cuenta)
	begin
		case cuenta is
		when comp1 => reg3 <=not reg1;
		when comp2 => reg3 <=(not reg1) + 1;
		when a_nd => reg3 <= reg1 and reg2;
		when o_r => reg3 <= reg1 or reg2;
		when lsl =>reg3 <= reg1 sll to_integer (reg2);
		when lsr => reg3 <= reg1 srl to_integer(reg2);
		when suma8=>reg4<= reg1+reg2;
		when resta8=>reg4<= reg1-reg2;
		when division8=>reg4<= reg1/reg2;
		when others=>reg3<=(others=>'0');
		
		end case;
		
	end process;
	Z1<=reg3;
	Z2<=reg4;
	
end Behavioral;