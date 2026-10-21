
module TopModule (
    input  wire [1:0] A,
    input  wire [1:0] B,
    output reg  z
);

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            z <= 1'b0;
        end else begin
            z <= (A == B) ? 1'b1 : 1'b0;
        end
    end

endmodule
