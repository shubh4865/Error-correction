module hc_enc#(
    parameter DATA_WD=4,
    parameter CHK_WD=3
)(
    input   logic   [4:1]   i_data,
    output  logic   [7:1] o_enc_data
);
    logic   [3:1]    chk_bits;
    logic   [7:1]    map_data;
    int j,k;

    always_comb begin
         o_enc_data[1]=i_data[1]^i_data[2]^i_data[4];
         o_enc_data[2]=i_data[1]^i_data[3]^i_data[4];
         o_enc_data[4]=i_data[2]^i_data[3]^i_data[4];
         o_enc_data[3]=i_data[1];
         o_enc_data[5]=i_data[2];
         o_enc_data[6]=i_data[3];
         o_enc_data[7]=i_data[4];
    
    end
endmodule
