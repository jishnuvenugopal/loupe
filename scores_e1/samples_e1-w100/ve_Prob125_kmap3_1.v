
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [2:0] karnaugh_map = {d, d, d, d, d, d, d, d, d, d, d, d, d, d, d, d};

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            out <= 1'b0;
        end else begin
            out <= karnaugh_map[a][b][c];
        end
    end

endmodule
