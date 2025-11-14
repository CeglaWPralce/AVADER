`timescale 1ns / 1ps

// =============================================================
// 1. MODUŁ: bytes_to_bits
// =============================================================
module bytes_to_bits (
    input clk,
    input rst_n,
    input [127:0] data,
    output [7:0] byte_out
);
    reg [3:0] index;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            index <= 4'd0;
        else
            index <= index + 1;              // 0,1,2,...,15,0,1,...
    end

    assign byte_out = data[127 - 8*index -: 8];  // MSB first
endmodule


// =============================================================
// 2. MODUŁ: uart_tx_fsm (poprawiony - bez błędu z bit_cnt!)
// =============================================================
module uart_tx_fsm (
    input clk,
    input rst_n,
    input send,           // impuls = zacznij bajt
    input [7:0] data,
    output reg txd,
    output reg done       // impuls po wysłaniu całego bajtu
);
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            bit_cnt  <= 0;
            data_reg <= 0;
            txd      <= 1'b1;
            done     <= 0;
        end else begin
            done <= 0;  // domyślnie 0

            case (state)
                IDLE: begin
                    txd <= 1'b1;
                    if (send) begin
                        data_reg <= data;
                        state    <= START;
                    end
                end
                START: begin
                    txd     <= 1'b0;
                    bit_cnt <= 0;
                    state   <= DATA;
                end
                DATA: begin
                    txd <= data_reg[bit_cnt];
                    if (bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                STOP: begin
                    txd  <= 1'b1;
                    done <= 1;           // ← tutaj sygnał "bajt wysłany"
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule


// =============================================================
// 3. MODUŁ: uart_tx_top - główna maszyna stanów
// =============================================================
module uart_tx_top (
    input clk,
    input rst_n,
    input start,                  // jeden impuls = wyślij 128 bitów
    input [127:0] data_in,
    output txd
);
    wire [7:0] current_byte;
    wire byte_done;
    reg  byte_send = 0;

    // Podłączenie modułów
    bytes_to_bits extractor (
        .clk     (clk),
        .rst_n   (rst_n),
        .data    (data_in),
        .byte_out(current_byte)
    );

    uart_tx_fsm transmitter (
        .clk  (clk),
        .rst_n(rst_n),
        .send (byte_send),
        .data (current_byte),
        .txd  (txd),
        .done (byte_done)
    );

    // Główna maszyna stanów
    reg [4:0] sent_count = 0;
    reg transmitting = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_send    <= 0;
            transmitting <= 0;
            sent_count   <= 0;
        end else begin
            byte_send <= 0;  // impuls tylko 1 cykl

            // Start całego pakietu
            if (start && !transmitting) begin
                transmitting <= 1;
                sent_count   <= 0;
                byte_send    <= 1;
            end

            // Po każdym ukończonym bajcie → start następnego
            else if (transmitting && byte_done) begin
                if (sent_count == 15) begin
                    transmitting <= 0;
                end else begin
                    byte_send  <= 1;
                    sent_count <= sent_count + 1;
                end
            end
        end
    end
endmodule