
module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

    
    reg Qold = 0;

    always @(posedge clk) begin
        
        Q = j ? ~Qold : k ? 1 : Qold;
    end

endmodule
