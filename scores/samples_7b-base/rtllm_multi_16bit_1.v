
module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
            
reg [15:0] areg;
        
reg [15:0] breg;
        
reg [31:0] yout_r;
      

reg done_r;
              

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
            end
            if (i < 5'd17) begin
                
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
            end else begin
                
                done_r <= 1'b1;
                i <= i + 1;
            end
        end else begin
            
            i <= 5'd0;
            done_r <= 1'b0;
        end
    end
end

assign done = done_r;
assign yout = yout_r;

endmodule
