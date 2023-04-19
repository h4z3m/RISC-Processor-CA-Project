library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_addressable_memory is
    port (
        clk : in std_logic;
        rdwr : in std_logic;
        addr : in unsigned(11 downto 0);
        size : in unsigned(1 downto 0);
        idata : in std_logic_vector(31 downto 0);
        odata : out std_logic_vector(31 downto 0);
        ivalid : out std_logic
    );
end entity byte_addressable_memory;

architecture rtl of byte_addressable_memory is
    type mem_type is array (4095 downto 0) of std_logic_vector(31 downto 0);
    signal mem : mem_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rdwr = '1' then
                case size is
                    when "00" =>
                        mem(to_integer(unsigned(addr))) <= idata(7 downto 0) & mem(to_integer(unsigned(addr)))(31 downto 8);
                        mem(to_integer(unsigned(addr))+1) <= idata(15 downto 8) & mem(to_integer(unsigned(addr))+1)(31 downto 16);
                        mem(to_integer(unsigned(addr))+2) <= idata(23 downto 16) & mem(to_integer(unsigned(addr))+2)(31 downto 24);
                        mem(to_integer(unsigned(addr))+3) <= idata(31 downto 24) & mem(to_integer(unsigned(addr))+3)(31 downto 24);
                    when "01" =>
                        mem(to_integer(unsigned(addr))) <= idata(15 downto 0) & mem(to_integer(unsigned(addr)))(31 downto 16);
                        mem(to_integer(unsigned(addr))+1) <= idata(31 downto 16) & mem(to_integer(unsigned(addr))+1)(31 downto 16);
                    when others =>
                        null;
                end case;
                -- Wait for write to complete
                for i in 1 to 8 loop
                    if i = 8 then
                        -- Writing complete
                        ivalid <= '0';
                    else
                        -- Writing still in progress
                        ivalid <= '1';
                    end if;
                    wait until rising_edge(clk);
                end loop;
            else
                case size is
                    when "00" =>
                        odata <= mem(to_integer(unsigned(addr)));
                    when "01" =>
                        odata <= mem(to_integer(unsigned(addr)));
                        odata(15 downto 0) <= (others => 'Z');
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end architecture rtl