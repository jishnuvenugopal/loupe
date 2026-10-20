
module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    
    reg [7:0] din_serial_reg;
    reg [2:0] cnt;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'b0;
        else if (din_valid)
            cnt <= cnt + 3'b1;
        else
            cnt <= cnt;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            din_serial_reg <= 8'b0;
        else if (din_valid)
            din_serial_reg <= {din_serial_reg[6:0], din_serial};
        else
            din_serial_reg <= din_serial_reg;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dout_parallel <= 8'b0;
        else if (cnt == 3'd8)
            begin
                dout_parallel <= din_serial_reg;
                dout_valid    <= 1'b1;
                cnt           <= 3'd0;
            end
        else
            begin
                dout_parallel <= 8'b0;
                dout_valid    <= 1'b0;
            end
    end

endmodule
