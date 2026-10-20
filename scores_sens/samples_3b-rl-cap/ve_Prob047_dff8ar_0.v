
module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output reg  [7:0]  q
);

    
    reg [7:0] d_ff;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            d_ff <= 8'b0;
        end else begin
            d_ff <= d;
        end
    end

    
    assign q = d_ff;

endmodule
