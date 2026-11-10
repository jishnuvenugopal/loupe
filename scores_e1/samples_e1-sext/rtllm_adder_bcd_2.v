
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
    if (Sum[3] == 1 && Sum[2] == 1 && Sum[1] == 1 && Sum[0] == 1) begin
        Sum = Sum + 6;
 
        Cout = 1;
      
    end else begin
        Cout = 0;
 
    end
end

endmodule
