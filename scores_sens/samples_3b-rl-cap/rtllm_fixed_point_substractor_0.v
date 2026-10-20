
module fixed_point_subtractor #(
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
    wire [Q-1:0] a_mag = a[Q-1:0];
    wire [Q-1:0] b_mag = b[Q-1:0];

    
    wire zero_result;

    
    assign zero_result = (a == 0) && (b == 0);

    
    assign res = (a_sign == b_sign) ? a - b : a + b;

    
    assign res = (a_sign != b_sign) ? (a > b ? a + b : -(a + b)) : res;

    
    always @(*) begin
        if (zero_result)
            c = {N{1'b0}};
 
        else
            c = res;
    end

endmodule
