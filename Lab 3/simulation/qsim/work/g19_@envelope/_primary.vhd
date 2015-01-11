library verilog;
use verilog.vl_types.all;
entity g19_Envelope is
    port(
        RISE_RATE       : in     vl_logic_vector(7 downto 0);
        FALL_RATE       : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        GATE            : in     vl_logic;
        ENVELOP         : out    vl_logic_vector(23 downto 0);
        UPDATE_ENABLE   : out    vl_logic
    );
end g19_Envelope;
