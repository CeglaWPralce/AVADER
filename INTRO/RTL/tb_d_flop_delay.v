module tb_delay_line;

    // === Parametry ===
    localparam DELAY = 4;         // Opóźnienie o 4 cykle
    localparam CLK_PERIOD = 10;   // Zegar: 100 MHz (10 ns)

    // === Sygnały ===
    reg  clk = 0;
    reg  din = 0;
    wire dout;

    // === Instancja DUT (Device Under Test) ===
    delay_line #(
        .DELAY(DELAY)
    ) dut (
        .clk(clk),
        .din(din),
        .dout(dout)
    );

    // === Generowanie zegara ===
    always #(CLK_PERIOD/2) clk = ~clk;

    // === Główny proces testowy ===
    initial begin
        $display("=== TESTBENCH: delay_line (DEPTH=%0d) ===", DEPTH);
        $display("Czas [ns] | din | dout | q_chain[%0d:0]", DEPTH-1);
        $display("----------+-----+------+------------------");

        // Czekamy kilka cykli na start (brak resetu → X na początku)
        repeat (DELAY + 1) @(posedge clk);

        // Test 1: Impuls 1-bitowy
        din = 1; #CLK_PERIOD;
        din = 0; #CLK_PERIOD;
        $display("%t |  %b  |  %b   | %b", $time, din, dout, dut.q_chain);

        // Test 2: Sekwencja 1010
        repeat (4) begin
            din = 1; #CLK_PERIOD;
            $display("%t |  %b  |  %b   | %b", $time, din, dout, dut.q_chain);
            din = 0; #CLK_PERIOD;
            $display("%t |  %b  |  %b   | %b", $time, din, dout, dut.q_chain);
        end

        // Test 3: Długa sekwencja
        # (CLK_PERIOD * 10);
        $display("--- Koniec testu ---");
        # (CLK_PERIOD * 5);
        $finish;
    end

    // === Monitor (opcjonalny) ===
    initial begin
        $monitor("%t | din=%b dout=%b", $time, din, dout);
    end

endmodule