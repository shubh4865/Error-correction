module hc_dec#(
    parameter DATA_WD = 4,
    parameter CHK_WD  = 3
)(
    input   logic   [DATA_WD+CHK_WD:1]  i_enc_data,
    output  logic                         o_err_flag,
    output  logic   [DATA_WD:1]         o_dec_data
);
    logic [3:1]  chk_bits_cmp;
    logic [7:1] corr_packet;
    logic [3:1]  err_pos;
    logic [3:1] chk_bits_ext;

    always_comb begin
    chk_bits_ext[1]=i_enc_data[1];
    chk_bits_ext[2]=i_enc_data[2];
    chk_bits_ext[3]=i_enc_data[4];
    chk_bits_cmp[1]=i_enc_data[3]^i_enc_data[5]^i_enc_data[7];
    chk_bits_cmp[2]=i_enc_data[3]^i_enc_data[6]^i_enc_data[7];
    chk_bits_cmp[3]=i_enc_data[5]^i_enc_data[6]^i_enc_data[7];
    err_pos[3]=chk_bits_ext[3]^chk_bits_cmp[3];
    err_pos[2]=chk_bits_ext[2]^chk_bits_cmp[2];
    err_pos[1]=chk_bits_ext[1]^chk_bits_cmp[1];
    corr_packet=i_enc_data;
    o_err_flag=|err_pos;

    if (err_pos!=3'b000) begin
        corr_packet[err_pos]=~corr_packet[err_pos];
        end

       o_dec_data[4:1] = {corr_packet[7],corr_packet[6],corr_packet[5],corr_packet[3]};
       end


`ifndef DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/hc_dec.vcd");
        $dumpvars(0, hc_dec);
     end
`endif

endmodule


