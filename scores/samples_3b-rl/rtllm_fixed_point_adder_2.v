
module fixed_point_adder #(
    parameter integer Q = 8,    
    parameter integer N = 16   
)(
    input  wire [N-1:0] a,     
    input  wire [N-1:0] b,     
    output reg  [N-1:0] c      
);

    
    reg [N-1:0] res;

    
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    
    wire [N-1:0] a_abs, b_abs;
    assign a_abs = (a_sign) ? ~a + 1'b1 : a;
    assign b_abs = (b_sign) ? ~b + 1'b1 : b;

    
    wire a_abs_greater = (a_abs > b_abs);
    wire b_abs_greater = (b_abs > a_abs);

    
    reg [N-1:0] result;
    assign result = (a_abs_greater) ? (a - b) : (b - a);

    
    assign c = result[N-1:Q];

    
    assign c[N-1] = a_sign;

    
    always @(*) begin
        res = result;
    end

    
    always @(*) begin
        c = res;
    end

endmodule
