
module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    
    reg [3:0] cnt;
    reg [0:0] din_serial_reg;

    
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            din_serial_reg <= 1'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            if (din_valid) begin
                din_serial_reg <= din_serial;
                cnt <= cnt + 1;
            end else begin
                
            end
            if (cnt == 4'd8) begin
                dout_parallel <= din_serial_reg;
                dout_valid <= 1'b1;
                cnt <= 4'd0;
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule
