module and2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;

endmodule





module and_cascade #(
    parameter N = 8  // liczba wejść, N >= 2
)(
    input  [N-1:0] in,
    output y
);

    // Sprawdzenie N >= 2
    generate
        if (N < 2) $error("Parametr N musi być >= 2");
    endgenerate

    // Sygnały pośrednie
    wire [N-2:0] chain;

    // === Pierwsza bramka AND (ręcznie) ===
    and2 u0 (
        .a(in[0]),
        .b(in[1]),
        .y(chain[0])
    );

    // === Kolejne bramki w pętli generate ===
    genvar i;
    generate
        for (i = 1; i < N-1; i = i + 1) begin : cascade
            and2 u_inst (
                .a(chain[i-1]),
                .b(in[i+1]),
                .y(chain[i])
            );
        end
    endgenerate

    // === Wyjście: ostatni element łańcucha ===
    assign y = chain[N-2];

endmodule