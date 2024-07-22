module hc_enc_dec#(
    parameter DATA_WD = 4,
    parameter CHK_WD  = 3
)(
    input   logic [DATA_WD:1] i_data,
    output  logic [DATA_WD:1] o_dec_data,
    output  logic o_err_flag,
    output  logic [DATA_WD+CHK_WD:1] o_enc_data
);

    logic [DATA_WD+CHK_WD:1] enc_data;

    // Encoder logic
    always_comb begin
        enc_data[1] = i_data[1] ^ i_data[2] ^ i_data[4];
        enc_data[2] = i_data[1] ^ i_data[3] ^ i_data[4];
        enc_data[4] = i_data[2] ^ i_data[3] ^ i_data[4];
        enc_data[3] = i_data[1];
        enc_data[5] = i_data[2];
        enc_data[6] = i_data[3];
        enc_data[7] = i_data[4];
    end

    assign o_enc_data = enc_data;

    // Decoder logic
    logic [3:1] chk_bits_cmp;
    logic [3:1] chk_bits_ext;
    logic [3:1] err_pos;
    logic [DATA_WD+CHK_WD:1] corr_packet;

    always_comb begin
        chk_bits_ext[1] = enc_data[1];
        chk_bits_ext[2] = enc_data[2];
        chk_bits_ext[3] = enc_data[4];
        chk_bits_cmp[1] = enc_data[3] ^ enc_data[5] ^ enc_data[7];
        chk_bits_cmp[2] = enc_data[3] ^ enc_data[6] ^ enc_data[7];
        chk_bits_cmp[3] = enc_data[5] ^ enc_data[6] ^ enc_data[7];
        err_pos[3] = chk_bits_ext[3] ^ chk_bits_cmp[3];
        err_pos[2] = chk_bits_ext[2] ^ chk_bits_cmp[2];
        err_pos[1] = chk_bits_ext[1] ^ chk_bits_cmp[1];
        corr_packet = enc_data;
        o_err_flag = |err_pos;

        if (err_pos != 3'b000) begin
            corr_packet[err_pos] = ~corr_packet[err_pos];
        end

        o_dec_data = {corr_packet[7], corr_packet[6], corr_packet[5], corr_packet[3]};
    end

endmodule

