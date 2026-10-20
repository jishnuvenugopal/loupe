
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q 
);

wire [511:0] next_q;

genvar i;

generate 
for (i=0;
 i <512;
 i = i +1 ) begin : gen_cell
    wire left_bit;
    assign left_bit = (i ==0) ? 1'b0 : q[i-1];

    wire right_bit;
    assign right_bit = (i ==511) ? 1'b0 : q[i+1];

    wire [2:0] current_rule_input;
    assign current_rule_input = {left_bit, q[i], right_bit};

    assign next_q[i] = 
        (current_rule_input == 3'b111) ? 1'b0 :
        (current_rule_input == 3'b110) ? 1'b1 :
        (current_rule_input == 3'b101) ? 1'b1 :
        (current_rule_input == 3'b100) ? 1'b0 :
        (current_rule_input == 3'b011) ? 1'b1 :
        (current_rule_input == 3'b010) ? 1'b1 :
        (current_rule_input == 3'b001) ? 1'b1 :
        (current_rule_input == 3'b000) ? 1'b0 : 1'b0;
end 
endgenerate 

always @(posedge clk) begin
    if (load)
        q <= data;
    else 
        q <= next_q;
end 

endmodule
