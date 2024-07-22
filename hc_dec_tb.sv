module hc_dec_tb;

 logic [7:1] i_enc_data;
 logic [4:1] o_dec_data;
 logic  o_err_flag;

hc_dec DUT (
      .i_enc_data(i_enc_data),
      .o_dec_data(o_dec_data),
      .o_err_flag(o_err_flag)
);

initial begin

 i_enc_data = 7'b0110111;  //encoded data with no error
#10;

 i_enc_data = 7'b0110011;  //encoded data with 1 bit error
#10;
 
 i_enc_data = 7'b0110110;  //encoded data with 1 bit error
#10;

 i_enc_data = 7'b0010111;  //encoded data with 1 bit error
#10;
 
 i_enc_data = 7'b0000000;  //encoded data with multiple error
#10;
 $stop;
   end
endmodule 