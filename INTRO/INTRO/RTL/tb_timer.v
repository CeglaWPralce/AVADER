module tb_cnt_modulo;
    localparam CLK_PERIOD = 10;

    reg clk = 0, ce = 0, rst = 1;
    wire [3:0] y6; wire tick6;
    wire [3:0] y10; wire tick10;

    always #(CLK_PERIOD/2) clk = ~clk;

    cnt_modulo #(.N(6))  dut6  (.clk(clk), .ce(ce), .rst(rst), .y(y6),  .tick(tick6));
    cnt_modulo #(.N(10)) dut10 (.clk(clk), .ce(ce), .rst(rst), .y(y10), .tick(tick10));

    initial begin
        $display("Czas | N=6: y tick | N=10: y tick");
        #20 rst = 0; ce = 1;
        forever begin
            @(posedge clk);
            $display("%t |  %2d  %b   |  %2d   %b", $time, y6, tick6, y10, tick10);
            if ($time >= 200) $finish;
        end
    end
endmodule