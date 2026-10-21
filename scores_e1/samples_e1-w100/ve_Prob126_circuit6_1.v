
module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    
    localparam CONSTANT = 16'h1232;

    
    reg [3:0] adder_out;

    always @(posedge a or negedge a) begin
        adder_out <= a + CONSTANT;
    end

    
    assign q = adder_out;

endmodule
