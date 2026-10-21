
module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    
    reg [0:0] sign_bit;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            sign_bit <= 0;
        end else begin
            sign_bit <= in[7];
        end
    end

    
    assign out = sign_bit << 24 | in;

endmodule
