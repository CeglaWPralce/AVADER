module tb_and_cascade;
    reg [7:0] in;
    wire y;

    // Instancja z N=8
    and_cascade #(.N(8)) dut (
        .in(in),
        .y(y)
    );

    initial begin
        // zrobic test wszystkich kombinacji
        in = 8'b11111111; #10 $display("%b | %b", in, y); // 1
        in = 8'b11111110; #10 $display("%b | %b", in, y); // 0
        in = 8'b10111111; #10 $display("%b | %b", in, y); // 0
        in = 8'b00000000; #10 $display("%b | %b", in, y); // 0

        #10 $finish;
    end
endmodule