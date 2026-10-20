
module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [4:0] i;
 
reg [15:0] areg;
 
reg [15:0] breg;
 
reg done_r;
 


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b0;
    end else begin
        if (start) begin
            if (i < 5'd17) begin
                i <= i + 1;
            end
        end else begin
            i <= 5'b0;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else begin
        if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end else begin
            done_r <= done_r;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        breg <= 16'b0;
        yout <= 32'b0;
    end else begin
        if (start) begin
            if (i == 5'b0) begin
                
                areg <= ain;
                breg <= bin;
                yout <= 32'b0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                
                if (areg[i-1]) begin
                    yout <= yout + ( {16'b0, breg} << (i-1) );
                end
            end
        end
    end
end

assign done = done_r;

endmodule
