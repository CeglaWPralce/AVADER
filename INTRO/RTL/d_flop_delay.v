module d_flop (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule



module delay_line #(
    parameter DELAY = 4  
)(
    input  clk,
    input  rst,
    input  din,
    output dout
);


    wire [DELAY-1:0] q_chain;
    wire d0 = din;

    
    genvar i;
    generate
        for (i = 0; i < DELAY; i = i + 1) begin : delay_chain
            d_flop ff_inst (
                .clk(clk),
                .rst(rst),
                .d(i == 0 ? d0 : q_chain[i-1]),
                .q(q_chain[i])
            );
        end
    endgenerate

    // === Wyjście: ostatni FF ===
    assign dout = (DELAY == 0) ? din : q_chain[DELAY-1];

endmodule
