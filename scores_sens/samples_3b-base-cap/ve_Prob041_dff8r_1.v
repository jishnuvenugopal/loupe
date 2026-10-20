
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] q0, q1, q2, q3, q4, q5, q6, q7;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q0 <= 8'b0;
            q1 <= 8'b0;
            q2 <= 8'b0;
            q3 <= 8'b0;
            q4 <= 8'b0;
            q5 <= 8'b0;
            q6 <= 8'b0;
            q7 <= 8'b0;
        end else begin
            q0 <= d;
            q1 <= q0;
            q2 <= q1;
            q3 <= q2;
            q4 <= q3;
            q5 <= q4;
            q6 <= q5;
            q7 <= q6;
        end
    end

    
    assign q = q7;

endmodule
