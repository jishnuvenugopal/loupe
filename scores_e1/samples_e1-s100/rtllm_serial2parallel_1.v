
module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_valid,
    input wire [7:0] din_serial,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;
  

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'b0;
  
            dout_parallel <= 8'b0;
  
            dout_valid <= 0;
  
        end else begin
            if (din_valid) begin
                cnt <= cnt + 1;
  
                if (cnt == 8) begin  
                    dout_parallel <= din_serial;
  
                    dout_valid <= 1;
  
                    cnt <= 4'b0;
  
                end else begin
                    dout_parallel <= 8'b0;
  
                    dout_valid <= 0;
  
                end
            end else begin
                dout_parallel <= 8'b0;
  
                dout_valid <= 0;
  
            end
        end
    end

endmodule
