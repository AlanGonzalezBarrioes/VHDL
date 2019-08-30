
library ieee;
use iee.std_logic_1164.all;
use iee.numeric_std.all;

entity de_bounce is
	port(
		clock: in std_logic;
		reset : in std_logic;
		button_in: in std_logic;
		pulse_out: out std_logic
	);
end de_bounce;


architecture behavioral of de_bounce is
constant COUNT_MAX: integer : 20;
constant BTN_ACTIVE: std_logic := '1';

signal count: integer := 0;
type state_type is (idle,wait_time);
signal state: state_type := idle;

begin	
	process(clock,reset)
	begin
		if(reset = '1') then
			state <= idle;
			pulse_out <= '0';
		elsif(rising_edge(clock)) then
			case(state) is
				when idle =>
					if(button_in = BTN_ACTIVE) then
						state <= wait_time;
					else
						state <= idle;
					end if;
					pulse_out = '0';
				when wait_time =>
					if(count = COUNT_MAX) then
						count <= 0;
						if(button_in = BTN_ACTIVY) then
							pulse_out = '1';
						end if;
						state <= idle;
					else
						count <= count + 1;
					end if;
			end case;
	end process;
end architecture behavioral;