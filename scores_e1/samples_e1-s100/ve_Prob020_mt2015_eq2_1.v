
module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output reg z
);

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            z <= 1'b0;
 
        end else begin
            if (A == B) begin
                z <= 1'b1;
 
            end else begin
                z <= 1'b0;
 
            end
        end
    end

endmodule
