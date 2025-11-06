`timescale 1ns / 1ps

module uart_tx_fsm (
    input  wire       clk,      // zegar
    input  wire       rst,      // reset (aktywny wysoki)
    input  wire       send,     // flaga startu transmisji
    input  wire [7:0] data,     // 8-bitowe dane do wysłania
    output reg        txd       // linia wyjściowa (1 bit)
);

    // === Stany maszyny ===
    localparam IDLE  = 2'd0;  // oczekiwanie na send
    localparam START = 2'd1;  // bit startu (0)
    localparam DATA  = 2'd2;  // przesyłanie 8 bitów
    localparam STOP  = 2'd3;  // bit stopu (1)

    // === Rejestry wewnętrzne ===
    reg [1:0] state = IDLE;
    reg [7:0] shift_reg;      // rejestr przesuwny dla danych
    reg [2:0] bit_cnt = 3'd0; // licznik bitów (0..7)

    // === Blok 1: Przejścia stanów i rejestr przesuwny (synchroniczny) ===
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
            txd       <= 1'b1;  // linia w spoczynku = 1
        end
        else begin
            case (state)
                IDLE: begin
                    txd <= 1'b1;  // linia w stanie wysokim
                    if (send) begin
                        state     <= START;
                        shift_reg <= data;  // załaduj dane
                    end
                end

                START: begin
                    txd   <= 1'b0;  // bit startu
                    state <= DATA;
                    bit_cnt <= 3'd0;
                end

                DATA: begin
                    txd <= shift_reg[0];  // LSB najpierw
                    shift_reg <= shift_reg >> 1;
                    if (bit_cnt == 3'd7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end

                STOP: begin
                    txd   <= 1'b1;  // bit stopu
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule