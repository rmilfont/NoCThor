library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity fifoBuffer is
    generic(
        B_DEPTH : natural;
        B_WIDTH : natural
    );
    port(
        reset :     in std_logic;
        clock :     in std_logic;
        head:       out std_logic_vector(B_WIDTH-1 downto 0);
        tail :      in std_logic_vector(B_WIDTH-1 downto 0);
        push :      in std_logic;
        pull :      in std_logic;
        counter :   out integer
    );
end;

architecture circularFifoBuffer of FifoBuffer is

    type buff is array(0 to B_DEPTH) of std_logic_vector(B_WIDTH-1 downto 0);
    signal buf: buff := (others=>(others=>'0'));

    signal isFull, isEmpty : boolean;
    signal first: integer := 0;
    signal last: integer := 0;
    signal auxCounter: integer;

begin

    counter <= auxCounter;
    head <= buf(first);
    auxCounter <= last - first when (last >= first) else B_DEPTH + 1 - (first - last);
    isFull <= auxCounter = B_DEPTH;
    isEmpty <= auxCounter = 0;

    process(reset, clock)
    begin
        if reset = '1' then
            last <= 0;
        elsif clock'event and clock = '1' then
            if not isFull and push = '1' then
                buf(last) <= tail;
                if last = B_DEPTH then
                    last <= 0;
                else last <= last + 1;
                end if;
            end if;
        end if;
    end process;

    process (reset, clock)
    begin
        if reset = '1' then
            first <= 0;
        elsif clock'event and clock = '1' then
            if not isEmpty and pull = '1' then
                if first = B_DEPTH then
                    first <= 0;
                else
                    first <= first + 1;
                end if;
            end if;
        end if;
    end process;

end circularFifoBuffer;
