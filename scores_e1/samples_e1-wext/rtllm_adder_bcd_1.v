
module adder_bcd (
    input wire [3:0] A,  
    input wire [3:0] B,  
    input wire Cin,    
    output reg [3:0] Sum, 
    output reg Cout     
);


always @(*) begin
    Sum = A + B + Cin;
end


always @(*) begin
    if (Sum >= 10) begin
        Sum = Sum - 10;
        Cout = 1;
    end else begin
        Cout = 0;
    end
end

endmodule
