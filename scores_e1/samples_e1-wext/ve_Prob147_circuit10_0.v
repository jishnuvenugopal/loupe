
module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    
    reg [1:0] ff;

    
    always @(posedge clk) begin
        if (a == 1'b1) begin
            ff <= 2'b10;
 
        end else begin
            ff <= ff;
 
        end
    end

    
    assign q = ff[1];

    
    assign state = ff[0];

endmodule
