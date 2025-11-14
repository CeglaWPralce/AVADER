module cnt_modulo #(
    parameter N = 8  // modulo N (licz od 0 do N-1)
    parameter WIDTH = $clog2(N)  // szerokość licznika
)(
    input  clk,
    input  ce,
    input  rst,
    
    output reg [WIDTH-1:0] y,  // szerokość optymalna
    output reg tick            // impuls co N cykli
);

    // Ochrona: N >= 2
    generate
        if (N < 2) $error("N musi być >= 2");
    endgenerate


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y    <= 0;
            tick <= 0;
        end else if (ce) begin
            if (y == N-1) begin
                y    <= 0;
                tick <= 1;        // impuls na końcu cyklu
            end else begin
                y    <= y + 1;
                tick <= 0;
            end
        end else begin
            tick <= 0;  // tick = 0 gdy ce = 0
        end
    end

endmodule