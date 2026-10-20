
module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

    
    reg q0, q1, q2, q3;

    
    always @(posedge resetn) begin
        q0 <= 1'b0;
        q1 <= 1'b0;
        q2 <= 1'b0;
        q3 <= 1'b0;
    end

    
    always @(posedge clk) begin
        
        q3 <= q2;
        q2 <= q1;
        q1 <= q0;
        
        q0 <= in;
    end

    
    assign out = q3;

endmodule
