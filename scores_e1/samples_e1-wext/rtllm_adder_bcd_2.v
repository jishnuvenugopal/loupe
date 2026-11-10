
module adder_bcd (
    input wire [3:0] A,  
    input wire [3:0] B,  
    input wire Cin,     
    output reg [3:0] Sum, 
    output reg Cout      
);

    
    reg [3:0] adder_output;

    
    assign adder_output = A + B + Cin;

    
    reg [3:0] corrected_sum;

    always @(adder_output) begin
        if (adder_output == 4'b1001) begin
            corrected_sum = adder_output + 4'b0110;
        end else begin
            corrected_sum = adder_output;
        end
    end

    
    assign Sum = corrected_sum;
    assign Cout = adder_output[3];

endmodule
