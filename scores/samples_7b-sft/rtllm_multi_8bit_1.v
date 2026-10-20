
module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

reg [16:0] accumulator;
 
reg [16:0] a_shifted;
   
integer i;

always @(*) begin
    accumulator = 17'b0;
    a_shifted = {9'b0, A};
 

    for (i = 0;
 i < 8;
 i = i + 1) begin
        if (B[i]) begin
            accumulator = accumulator + a_shifted;
        end
        a_shifted = a_shifted << 1;
 
    end

    product = accumulator[15:0];
 
end

endmodule
