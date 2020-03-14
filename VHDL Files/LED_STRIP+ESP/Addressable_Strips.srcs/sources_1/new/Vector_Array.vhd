library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Vector_Array is

   type t_Vector_Array is array(natural range <>) of std_logic_vector(7 downto 0);

end  Vector_Array;