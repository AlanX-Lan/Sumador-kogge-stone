library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Definición de la entidad
entity sumador_ks is
    port (
        A, B : in std_logic_vector(3 downto 0);
        Cin  : in std_logic;
        Sum  : out std_logic_vector(3 downto 0);
        Cout : out std_logic
    );
end entity sumador_ks;

-- Arquitectura del sumador Kogge-Stone
architecture Behavioral of sumador_ks is
    signal G, P : std_logic_vector(2 downto 0);
    signal C : std_logic_vector(3 downto 0);
    signal Cin_uns : unsigned(0 downto 0);

begin
    -- Generación de las señales generadoras G y P
    G(0) <= A(0) and B(0);
    P(0) <= A(0) xor B(0);

    G(1) <= (A(1) and B(1)) or (A(1) and G(0)) or (B(1) and G(0));
    P(1) <= A(1) xor B(1) xor G(0);

    G(2) <= (A(2) and B(2)) or (A(2) and G(1)) or (B(2) and G(1));
    P(2) <= A(2) xor B(2) xor G(1);

    -- Generación de las señales de acarreo C
    C(0) <= Cin;
    C(1) <= G(0) or (P(0) and Cin);
    C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and Cin);
    C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and Cin);

    -- Conversión de tipo para Cin
    Cin_uns <= unsigned'(to_unsigned(to_integer(unsigned'("0" & Cin)), 1));

    -- Cálculo de la suma y el acarreo de salida
    Sum <= std_logic_vector(resize(unsigned(A) xor unsigned(B) xor Cin_uns, Sum'length));
    Cout <= C(3);
end architecture Behavioral;
