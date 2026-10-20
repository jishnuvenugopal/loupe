
module serial2parallel (
    input wire clk,          
    input wire rst_n,        
    input wire din_serial,   
    input wire din_valid,    
    output reg [7:0] dout_parallel, 
    output reg dout_valid    
);

reg [2:0] cnt;
  

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_parallel <= 8'b0;
        dout_valid <= 0;
        cnt <= 3'b0;
    end else begin
        dout_valid <= 0;
        if (din_valid) begin
            dout_parallel[cnt] <= din_serial;
            cnt <= cnt + 1;
            if (cnt == 3'b111) begin
                cnt <= 3'b000;
                dout_valid <= 1;
            end
        end
    end
end

endmodule
