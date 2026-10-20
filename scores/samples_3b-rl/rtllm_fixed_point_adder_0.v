
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

    
    wire [Q-1:0] a_abs = a[Q-1:0];
    wire [Q-1:0] b_abs = b[Q-1:0];

    
    wire a_abs_greater = (a_abs > b_abs);
    wire a_greater = (a > b);

    
    always @(*) begin
        if (a_sign == b_sign) begin
            
            res = a + b;
        end else begin
            if (a_abs_greater) begin
                
                res = a - b;
            end else begin
                
                res = b - a;
            end
        end
    end

    
    assign res[N-1] = a_sign;

    
    assign c = res;

endmodule
