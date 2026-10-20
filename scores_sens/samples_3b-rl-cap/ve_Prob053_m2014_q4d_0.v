
module TopModule (
    input clk,
    input in,
    output out
);

    reg out;

    
    wire xor_out;
    assign xor_out = out ^ in;

    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule
