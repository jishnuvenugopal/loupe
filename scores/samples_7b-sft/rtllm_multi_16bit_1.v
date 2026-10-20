
module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg, breg;
reg [4:0] i;
reg [31:0] yout_r;
reg done_r;

assign yout = yout_r;
assign done = done_r;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b0;
    end else begin
        if (start && (i < 17)) begin
            i <= i + 1;
        end else begin
            i <= 5'b0;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else begin
        if (i == 16) begin
            done_r <= 1'b1;
        end else if (i == 17) begin
            done_r <= 1'b0;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        breg <= 16'b0;
    end else begin
        if (i == 0 && start) begin
            areg <= ain;
            breg <= bin;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 32'b0;
    end else begin
        if (i == 0 && start) begin
            yout_r <= 32'b0;
        end else if (i > 0 && i < 17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + ( { {16{1'b0}}, breg } << (i-1) );
            end
        end
    end
end

endmodule
