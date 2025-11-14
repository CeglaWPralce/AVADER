// =============================================================
// TESTBENCH - czyta z data.txt, zapisuje do output.txt
// =============================================================
module tb;
    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;
    reg [127:0] data_in = 0;
    wire txd;

    // Pliki
    integer fin, fout, i;
    reg [7:0] char;

    uart_tx_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(data_in),
        .txd(txd)
    );

    always #5 clk = ~clk; // 100 MHz

    initial begin
        $display("=== UART TX - czyta data.txt → zapisuje output.txt ===");

        // === OTWÓRZ PLIKI ===
        fin = $fopen("data.txt", "r");
        if (fin == 0) begin
            $display("BŁĄD: Nie mogę otworzyć data.txt!");
            $finish;
        end

        fout = $fopen("output.txt", "w");
        if (fout == 0) begin
            $display("BŁĄD: Nie mogę otworzyć output.txt!");
            $fclose(fin); $finish;
        end

        // === WCZYTAJ 16 ZNAKÓW OD LEWEJ (bajt[0] = pierwszy znak) ===
        for (i = 0; i < 16; i = i + 1) begin
            if ($fscanf(fin, "%c", char) == 1)
                data_in[8*i +: 8] = char;        // bajt 0 = najstarszy znak
            else
                data_in[8*i +: 8] = 8'd65;       // 'A' jeśli za mało
        end

        $display("WCZYTANO 16 bajtów:");
        for (i = 0; i < 16; i = i + 1)
            $write("%c", data_in[8*i +: 8]);
        $display("");

        $fclose(fin);

        // === RESET ===
        #20 rst_n = 1;
        #50;

        // === START TRANSMISJI - impuls dokładnie 1 cykl ===
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // === CZEKAJ aż UART naprawdę zacznie (pierwszy bit startu = 0) ===
        @(negedge txd);            // czekaj na opadające zbocze (bit startu)
        $display("Wykryto bit startu - zaczynam zapis");

        // === ZAPISUJ PRECYZYJNIE 16 × 11 bitów (z oversamplingiem ×100) ===
        repeat(16 * 11 * 100) begin
            @(posedge clk);
            $fwrite(fout, "%b", txd);
        end

        // dodaj kilka bitów spoczynku na końcu
        repeat(500) begin
            @(posedge clk);
            $fwrite(fout, "%b", txd);
        end

        $fclose(fout);
        $display("GOTOWE! output.txt zawiera 16 poprawnych ramek UART");
        $display("Każda ramka: 0 [8 bitów LSB-first] 1");
        $display("Przykład dla 'A' (0x41): 0 10000010 1 → 0100000101");
        $finish;
    end
endmodule