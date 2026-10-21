
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    
    reg [4:0] delay = 5;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            q <= 1'b0;
        end else begin
            q <= a & b & c & d;
        end
    end

endmodule
