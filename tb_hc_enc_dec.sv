module tb_hc_enc_dec;

    // Parameters
    parameter DATA_WD = 4;
    parameter CHK_WD  = 3;

    // Testbench signals
    logic [DATA_WD:1] i_data;
    logic [DATA_WD+CHK_WD:1] enc_data;
    logic o_err_flag;
    logic [DATA_WD:1] dec_data;

    // Instantiate the encoder module
    hc_enc #(
        .DATA_WD(DATA_WD),
        .CHK_WD(CHK_WD)
    ) encoder (
        .i_data(i_data),
        .o_enc_data(enc_data)
    );

    // Instantiate the decoder module
    hc_dec #(
        .DATA_WD(DATA_WD),
        .CHK_WD(CHK_WD)
    ) decoder (
        .i_enc_data(enc_data),
        .o_err_flag(o_err_flag),
        .o_dec_data(dec_data)
    );

    // Testbench procedure
    initial begin
        // Test various input values and potential single-bit errors
        test_case(4'b0000);
        test_case(4'b0001);
        test_case(4'b0010);
        test_case(4'b0011);
        test_case(4'b0100);
        test_case(4'b0101);
        test_case(4'b0110);
        test_case(4'b0111);
        test_case(4'b1000);
        test_case(4'b1001);
        test_case(4'b1010);
        test_case(4'b1011);
        test_case(4'b1100);
        test_case(4'b1101);
        test_case(4'b1110);
        test_case(4'b1111);

        // End simulation
        $finish;
    end

    // Task to test a single case
    task test_case(input [DATA_WD:1] data);
        begin
            // Apply input data
            i_data = data;
            #10;

            // Display results without error
            $display("Time: %0t | Input: %b | Encoded: %b | Decoded: %b | Error Flag: %b", $time, i_data, enc_data, dec_data, o_err_flag);

            // Introduce single-bit errors and test
            for (int i = 1; i <= DATA_WD + CHK_WD; i++) begin
                enc_data[i] = ~enc_data[i]; // Introduce error
                #10;
                $display("Time: %0t | Input: %b | Encoded with Error: %b | Decoded: %b | Error Flag: %b", $time, i_data, enc_data, dec_data, o_err_flag);
                enc_data[i] = ~enc_data[i]; // Correct the error
            end
        end
    endtask

endmodule
