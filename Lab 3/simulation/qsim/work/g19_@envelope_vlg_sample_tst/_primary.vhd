library verilog;
use verilog.vl_types.all;
entity g19_Envelope_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        FALL_RATE       : in     vl_logic_vector(7 downto 0);
        GATE            : in     vl_logic;
        reset           : in     vl_logic;
        RISE_RATE       : in     vl_logic_vector(7 downto 0);
        sampler_tx      : out    vl_logic
    );
end g19_Envelope_vlg_sample_tst;
