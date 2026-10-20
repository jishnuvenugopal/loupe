
module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);

    
    reg q_internal;

    
    always @(posedge ar) begin
        q_internal <= 1'b0;
 
    end

    
    always @(posedge clk) begin
        if (ar == 1'b0) begin
            q_internal <= d;
 
        end
    end

    
    assign q = q_internal;

endmodule
