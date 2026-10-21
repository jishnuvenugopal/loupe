
module adder_bcd (
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    
    reg [3:0] add;
    always @(posedge Cin or posedge A or posedge B) begin
        add = A + B;
        if (add > 9) begin
            add = add - 10;
 
            Cout = 1'b1;
 
        end else begin
            Cout = 1'b0;
 
        end
    end

    
    reg [3:0] corrected_sum;
    always @(posedge Cin or posedge add) begin
        corrected_sum = add;
        if (corrected_sum > 9) begin
            corrected_sum = corrected_sum - 10;
 
            Cout = 1'b1;
 
        end else begin
            Cout = 1'b0;
 
        end
    end

    
    assign Sum = corrected_sum;

endmodule
