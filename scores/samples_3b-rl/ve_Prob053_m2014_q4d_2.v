
module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    
    wire xor_out;

    
    always @ (out or in) begin
        xor_out = out ^ in;
    end

    
    always @ (posedge clk) begin
        out <= xor_out;
    end

endmodule
