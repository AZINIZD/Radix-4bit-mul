library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (15 downto 0);
           y : in STD_LOGIC_VECTOR (15 downto 0);
           out : out STD_LOGIC_VECTOR (31 downto 0));
end multiplier;

architecture Behavioral of multiplier is
    signal c : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal pp : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- partial products
    signal spp : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- shifted partial products
    signal prod : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal i, j : INTEGER := 0;
    signal flag : BOOLEAN := FALSE;
    signal inv_x : STD_LOGIC_VECTOR(15 downto 0); -- two's complement of x

begin
    inv_x <= NOT x + "0000000000000001"; -- two's complement

    process(clk, reset)
    begin
        if reset = '1' then
            out <= (others => '0');
            c <= (others => '0');
            pp <= (others => '0');
            flag <= FALSE;
            spp <= (others => '0');
            i <= 0;
            j <= 0;
            prod <= (others => '0');
        elsif rising_edge(clk) then
            if not flag then
                c <= y & y(15 downto 14); -- initializing c with y
                flag <= TRUE;
            end if;

            case c is
                when "000" | "111" =>
                    if i < 8 then
                        i <= i + 1;
                        c <= y(2*i+1 downto 2*i-1);
                    else
                        c <= "XXX";
                    end if;

                when "001" | "010" =>
                    if i < 8 then
                        i <= i + 1;
                        c <= y(2*i+1 downto 2*i-1);
                        pp <= x & x; -- generating partial product
                        if i = 1 then 
                            prod <= pp;
                        else
                            j <= i - 1;
                            j <= j * 2; -- shifting left by one position
                            spp <= pp sll j; -- shifting partial product
                            prod <= prod + spp; -- adding shifted partial product
                        end if;
                    end if;

                -- Additional cases for other values of c can be added here

                when others =>
                    null; -- handle other cases as needed

            end case;
            out <= prod; -- output the product at each clock cycle
        end if;
    end process;

end Behavioral;
