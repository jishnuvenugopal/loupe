
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
reg [15:0] i, done_r;

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        if (start == 1'b1) begin
            if (i < 17) begin
                i <= i + 1;
                if (i == 16) begin
                    done_r <= 1'b1;
                end else if (i == 17) begin
                    done_r <= 0;
                end
            end else begin
                if (i == 0) begin
                    areg <= ain;
                    breg <= bin;
                end else begin
                    yout_r <= yout_r << i - 1;
                    yout_r <= yout_r | (breg << (i - 1));
                end
            end
        end else begin
            i <= 0;
            done_r <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
