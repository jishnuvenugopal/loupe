
module adder_bcd (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    
    reg [3:0] add_result;

    always @(posedge Cin or posedge A or posedge B) begin
        add_result = A + B;
    end

    
    reg [3:0] corrected_sum;

    always @(posedge add_result or posedge Cin) begin
        corrected_sum = add_result + Cin;
    end

    
    reg [1:0] carry;

    always @(posedge corrected_sum or posedge Cin) begin
        carry = corrected_sum[3];
        Sum = corrected_sum[2:0];
    end

endmodule
