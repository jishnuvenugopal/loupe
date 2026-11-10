
module adder_bcd (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output reg [3:0] Sum,
    output reg Cout
);

always @(*) begin
    
    reg [3:0] add_result = A + B;

    
    if (add_result >= 10) begin
        
        add_result = add_result + 6;
        
        Cout = 1'b1;
    end else begin
        
        Cout = 1'b0;
    end

    
    Sum = add_result;
end

endmodule
