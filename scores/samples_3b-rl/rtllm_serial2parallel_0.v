
module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;
    reg [7:0] dout_parallel_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt         <= 4'b0000;
            dout_parallel <= 8'b0;
            dout_valid   <= 1'b0;
        end else begin
            if (din_valid) begin
                case (cnt)
                    4'd0: dout_parallel_reg[0] <= din_serial;
                    4'd1: dout_parallel_reg[1] <= din_serial;
                    4'd2: dout_parallel_reg[2] <= din_serial;
                    4'd3: dout_parallel_reg[3] <= din_serial;
                    4'd4: dout_parallel_reg[4] <= din_serial;
                    4'd5: dout_parallel_reg[5] <= din_serial;
                    4'd6: dout_parallel_reg[6] <= din_serial;
                    4'd7: dout_parallel_reg[7] <= din_serial;
                    4'd8: begin
                        dout_parallel <= dout_parallel_reg;
                        dout_valid    <= 1'b1;
                        cnt           <= 4'b0000;
                        dout_valid    <= 1'b0;
                    end
                    default: cnt <= cnt + 1;
                endcase
            end else begin
                cnt         <= cnt;
                dout_parallel <= dout_parallel;
                dout_valid   <= 1'b0;
            end
        end
    end

    assign dout_parallel = dout_parallel_reg;

endmodule
