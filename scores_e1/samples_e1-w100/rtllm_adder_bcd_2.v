
module adder_bcd (
    input wire [3:0] A,  
    input wire [3:0] B,  
    input wire Cin,     
    output reg [3:0] Sum, 
    output reg Cout      
);


reg [3:0] adder_output;

always @(A, B, Cin) begin
    adder_output = A + B + Cin;
end


always @(adder_output) begin
    if (adder_output == 4'b1001) begin
        Sum = adder_output + 4'b0110;
        Cout = 1'b1;
    end else begin
        Sum = adder_output;
        Cout = 1'b0;
    end
end

endmodule
