
module TopModule (
    input wire in,
    output reg out
);

    
    always @(posedge in) begin
        out <= in;
    end

endmodule
