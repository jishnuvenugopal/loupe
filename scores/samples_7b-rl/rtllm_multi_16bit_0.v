
module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i;
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 5'd0;
    else begin
        if (start) begin
            if (i < 17)
                i <= i + 1;
        end else
            i <= 5'd0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 1'b0;
    else begin
        if (i == 16)
            done_r <= 1'b1;
        else if (i == 17)
            done_r <= 1'b0;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 0) begin
            
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end else if (i >=1 && i <17) begin
            
            if (areg[i-1]) begin
                yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            end
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
