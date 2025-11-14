`timescale 1ns / 1ps
module tb_or_and_tree;

    // === Instancje DUT dla N=2,4,8 ===
    wire Z2, Z4, Z8;
    or_and_tree #(.N(2)) dut2 (.X(X2), .Y(Y2), .Z(Z2));
    or_and_tree #(.N(4)) dut4 (.X(X4), .Y(Y4), .Z(Z4));
    or_and_tree #(.N(8)) dut8 (.X(X8), .Y(Y8), .Z(Z8));

    // Sygnały wejściowe
    reg [1:0] X2, Y2;
    reg [3:0] X4, Y4;
    reg [7:0] X8, Y8;

    // === Testy z wpisanymi wynikami ===
    initial begin
        $display("=== TESTY OR na nieparzystych poziomach ===");

        // --- N=8 ---
        X8 = 8'hFF; Y8 = 8'hFF; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 1)", X8, Y8, Z8);
        (Z8 === 1'b1) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'h00; Y8 = 8'hFF; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'hFF; Y8 = 8'h00; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'hAA; Y8 = 8'hAA; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'h01; Y8 = 8'h01; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'h80; Y8 = 8'h80; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'hF0; Y8 = 8'hF0; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        X8 = 8'h55; Y8 = 8'h55; #1;
        $display("N=8: X=%b Y=%b → Z=%b (oczekiwano 0)", X8, Y8, Z8);
        (Z8 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        // --- N=4 ---
        X4 = 4'hF; Y4 = 4'hF; #1;
        $display("N=4: X=%b Y=%b → Z=%b (oczekiwano 1)", X4, Y4, Z4);
        (Z4 === 1'b1) ? $display("  OK") : $error("  BŁĄD!");

        X4 = 4'h5; Y4 = 4'h5; #1;
        $display("N=4: X=%b Y=%b → Z=%b (oczekiwano 1)", X4, Y4, Z4);
        (Z4 === 1'b1) ? $display("  OK") : $error("  BŁĄD!");

        // --- N=2 ---
        X2 = 2'b11; Y2 = 2'b11; #1;
        $display("N=2: X=%b Y=%b → Z=%b (oczekiwano 1)", X2, Y2, Z2);
        (Z2 === 1'b1) ? $display("  OK") : $error("  BŁĄD!");

        X2 = 2'b01; Y2 = 2'b01; #1;
        $display("N=2: X=%b Y=%b → Z=%b (oczekiwano 0)", X2, Y2, Z2);
        (Z2 === 1'b0) ? $display("  OK") : $error("  BŁĄD!");

        #10 $finish;
    end

endmodule