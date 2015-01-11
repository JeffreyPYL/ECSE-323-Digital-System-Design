library verilog;
use verilog.vl_types.all;
entity g19_Envelope_vlg_check_tst is
    port(
        ENVELOP         : in     vl_logic_vector(23 downto 0);
        UPDATE_ENABLE   : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end g19_Envelope_vlg_check_tst;
