library ieee;
use iee.std_logic_1164.all;
use iee.numeric_std.all;

entity alu is port(
		clock, reset: in std_logic;
		pulse_ope,pulse_load:std_logic; --PULSO PARA BOTON OPERACIONES Y BOTON CARGA
		A: in std_logic_vector(7 downto 0);
		z1,z2: out signed(7 downto 0)
		

);


end alu;

architecture behavioral of alu is

type estados is (comp1,comp2,a_nd,o_r,lsl,lsr,suma8,resta8,division8);
signal present_state, next_state : state;


signal num_bcd: std_logic_vector(10 downto 0):=(others=>'0');--numero convertido a BCD


signal salida1: std_logic_vector(7 downto 0):=(others=>'0');--salida para Operaciones logicas
signal salida2: signed(7 downto 0):=(others=>'0');--salida para Operaciones aritmeticas

signal out_ope;--pulso de salida para boton realizar operaciones
signal out_load;--pulso de salida para boton cargar numero1 y numero 2





signal num1:signed(7 downto 0):=(others=>'0'); --Numero 1
signal num2:signed(7 downto 0):=(others=>'0'); --Numero 2

signal D0,D1,D2,D3 : STD_LOGIC_VECTOR(3 downto 0); --vectores para almacenar numero en bcd

signal diplay0,diplay1,diplay2,diplay3: STD_LOGIC_VECTOR(6 downto 0); --display del FPGA

--DECLARACION DEL COMPONENTE de_bounce
	component de_bounce
		port(
			clock: in std_logic;
			reset : in std_logic;
			button_in: in std_logic;
			button_out: out std_logic
			);
	end component;

--DECLARACION DEL COMPONENTE bin2bcd
	component bin2bcd
		port(
			num_bin: in  STD_LOGIC_VECTOR(7   downto 0);
			num_bcd: out STD_LOGIC_VECTOR(10 downto 0)
			);
	end component;
	
--DECLARACION DEL COMPONENTE siete_segmentos
	component siete_segmentos
		port(
			 A: IN  STD_LOGIC_VECTOR(3 downto 0);
			 Z : OUT STD_LOGIC_VECTOR(6 downto 0)
			);
	end component;

begin

--INSTANCIACION DE COMPONENTE de_bounce PARA CONTROL DE BOTON operaciones
	entidad_operaciones: de_bounce port map(
			clock => clock,
			reset => reset,
			button_in => pulse_ope,
			pulse_out => out_ope
		 );
		 
--INSTANCIACION DE COMPONENTE de_bounce PARA CONTROL DE BOTON carga
	entidad_carga: de_bounce port map(
			clock => clock,
			reset => reset,
			button_in => pulse_load,
			pulse_out => out_load
		 );
		 
--PROCESO PARA CARGA DE DATOS		
		carga: process(out_load)
			   begin
				if(pulse_out='0') then
					num1 <= A;
				else
					num2 <= A;
				end if;
		end process carga;

--PROCESO PARA INICIALIZACION DE present_state	
		init: process(out_ope)
					 begin
						if(out_ope='1') then
							if(reset='1') then
								present_state<=comp1;
							end if;
						else 
							present_state<=next_state;
						end if;
					end process init;
					
--PROCESO PARA TRANSICION DE next_state	Y APLICACION DE ALU			
		FSM: process(present_state) 
			 begin
				case(present_state) is
					when comp1 =>
						salida1 <= not A;
						next_state <= comp1;
						
					when comp2 =>
						salida1 <= (not A) + 1;
						next_state <= a_nd;
						
					when a_nd =>
						salida1 <= num1 and num2;
						next_state <= o_r;
						
					when o_r =>
						salida1 <= num1 or num2;
						next_state <= lsl;
						
					when lsl => 
						salida1 <= num1 sll to_integer (num2);
						next_state <= lsr;
						
					when lsr => 
						salida1 <= num1 srl to_integer (num2);
						next_state <= suma8;
						
					when suma8 => 
						salida2 <= num1 + num2;
						next_state <= resta8;
						
					when resta8 => 
						salida2 <= num1 - num2;
						next_state <= division8;
						
					when division8 => 
						salida2 <= num1 / num2;
						next_state <= comp1;
						
					when others => 
						next_state <= comp1;
						
				end case;
				z1 <= salida1;-- Salida hacia los leds
			end process FSM;
			
--PROCESO PARA CONVERTIR LA salida2 A CODIGO BCD
		convertidor_binario_bcd: process(salida2)
					 begin
					 
						entidad_bcd: binarytobcd port map(
							num_bin =>salida2,
							num_bcd => num_bcd
						);
					 
					 end process convertidor_binario_bcd;
			
--PROCESO PARA DIVIDIR num_bcd EN PAQUETES DE 4 BITS PARA MOSTRAR EN LOS 4 DISPLAYS DEL FPGA			
		bcd_7segmentos:process(num_bcd)
					   begin
						 D3 <="0000";
						 D2 <= "0" & num_bcd(10 downto 8);
						 D1 <= num_bcd(7 downto 4);
						 D0 <= num_bcd(3 downto 0);
						 
						 
					   end process bcd_7segmentos;
					   
					   
--PROCESO PARA MOSTRAR RESULTADO EN LOS DISPLAYS					
		display_7segmentos:process(D0,D1,D2,D3)
						   begin
						   
						   --INSTANCIACION DEL COMPONENTE siete_segmentos PARA EL LA SALIDA HACIA EL DISPLAY 1 DEL FPGA
						   entidad_display0: siete_segmentos port map(
							A =>D0,
							Z => diplay0
							);
							
							--INSTANCIACION DEL COMPONENTE siete_segmentos PARA EL LA SALIDA HACIA EL DISPLAY 2 DEL FPGA
							entidad_display1: siete_segmentos port map(
							A =>D0,
							Z => diplay1
							); 
							
							--INSTANCIACION DEL COMPONENTE siete_segmentos PARA EL LA SALIDA HACIA EL DISPLAY 3 DEL FPGA
							entidad_display2: siete_segmentos port map(
							A =>D0,
							Z => diplay2
							);
							
							--INSTANCIACION DEL COMPONENTE siete_segmentos PARA EL LA SALIDA HACIA EL DISPLAY 4 DEL FPGA
							entidad_display3: siete_segmentos port map(
							A =>D0,
							Z => diplay3
							);
						   
						   end process display_7segmentos;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
end architecture behavioral;