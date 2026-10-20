
module TopModule (
    input  clk,
    input  reset,
    input [7:0] in,
    output reg done
);

reg [2:0] byte_count;
reg byte_received;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        byte_count <= 3'b000;
        byte_received <= 1'b0;
        done <= 1'b0;
    end else begin
        if (byte_received == 1'b0) begin
            if (in[3]) begin
                byte_count <= 3'b001;
                byte_received <= 1'b1;
            end
        end else begin
            if (byte_count == 3'b002) begin
                done <= 1'b1;
            end else begin
                byte_count <= byte_count + 3'b001;
            end
        end
    end
end

endmodule
