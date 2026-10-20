
module div_16bit (
    input wire [15:0] A, 
    input wire [7:0]  B,  
    output reg [15:0] result, 
    output reg [15:0] odd   
);

reg [15:0] a_reg;
 
reg [7:0]  b_reg;
  
reg [4:0]  shift_count;
 

always @(A or B) begin
    a_reg = A;
 
    b_reg = B;
 
    shift_count = 5'b00000;
 
    result = 16'b0;
 
    odd = 16'b0;
 
end

always @(A or B or shift_count) begin
    while (shift_count < 16) begin
        if (a_reg[15:8] >= b_reg) begin 
            a_reg[15:8] = a_reg[15:8] - b_reg;
 
            result[shift_count] = 1;
 
        end else begin
            result[shift_count] = 0;
 
        end
        a_reg = {a_reg[7:0], 1'b0};
 
        shift_count = shift_count + 1;
 
    end
    odd = a_reg;
 
end

endmodule
