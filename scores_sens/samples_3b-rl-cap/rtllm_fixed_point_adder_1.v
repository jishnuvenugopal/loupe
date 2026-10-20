
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

    
    wire a_pos = a_sign;
    wire b_pos = b_sign;
    wire [N-1:0] larger_abs;
    wire larger_abs_sign;

    always @(*) begin
        if (a_abs > b_abs) begin
            larger_abs = a_abs;
            larger_abs_sign = a_sign;
        end else begin
            larger_abs = b_abs;
            larger_abs_sign = b_sign;
        end
    end

    
    always @(*) begin
        if (a_sign == b_sign) begin
            
            res = a_abs + b_abs;
            res[N-1] = a_sign;
 
        end else begin
            
            res = larger_abs;
            res[N-1] = larger_abs_sign;
 
        end
    end

    
    assign c = res;

endmodule
