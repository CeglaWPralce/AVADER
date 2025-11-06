`timescale 1ns / 1ps
module and2 (input a, b, output y); assign y = a & b; endmodule
module or2  (input a, b, output y); assign y = a | b; endmodule

module or_and_tree #(
    parameter N = 8  // liczba par (X,Y) – musi być potęgą 2
)(
    input  [N-1:0] X,
    input  [N-1:0] Y,
    output         Z
);

    // === Ochrona: N = 2^k >= 2 ===
    if ((N & (N-1)) != 0 || N < 2)
        $error("N musi być potęgą 2 (>= 2)");

    localparam LEVELS = $clog2(N);  // liczba poziomów

    // === Sygnały dla każdego poziomu: level[lvl][szerokość] ===
    wire [N-1:0] level [0:LEVELS];

    // Poziom 0: X & Y (zawsze AND)
    assign level[0] = X & Y;

    genvar lvl, i;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : reduce
            localparam CURR_WIDTH = N >> (lvl - 1);
            localparam NEXT_WIDTH = CURR_WIDTH >> 1;

            for (i = 0; i < NEXT_WIDTH; i = i + 1) begin : pair
                // Nieparzysty poziom (1,3,5...) → OR
                // Parzysty poziom (0,2,4...) → AND (już zrobione na wejściu)
                if (lvl % 2 == 1) begin
                    or2 gate (
                        .a(level[lvl-1][2*i]),
                        .b(level[lvl-1][2*i+1]),
                        .y(level[lvl][i])
                    );
                end else begin
                    and2 gate (
                        .a(level[lvl-1][2*i]),
                        .b(level[lvl-1][2*i+1]),
                        .y(level[lvl][i])
                    );
                end
            end
        end
    endgenerate

    assign Z = level[LEVELS][0];

endmodule