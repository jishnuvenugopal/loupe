
module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg, breg, yout_r;
reg [15:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (i < 17) begin
                if (areg[i-1] == 1'b1) begin
                    yout_r <= yout_r << i | breg;
                end
            end
        end
        i <= i + 1;
        done_r <= i == 16;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
