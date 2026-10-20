
module fixed_point_subtractor #(
    parameter integer Q = 8,   
    parameter integer N = 16  
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    
    reg [N-1:0] res;
    wire [N-1:0] a_int, b_int, a_frac, b_frac;
    wire [N-1:0] abs_a, abs_b;
    wire [N-1:0] a_sign, b_sign;
    wire [N-1:0] zero = 16'b0;

    
    assign a_int  = a[N-1-Q-1:0];
    assign a_frac = a[N-1:Q+1];
    assign b_int  = b[N-1-Q-1:0];
    assign b_frac = b[N-1:Q+1];

    
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];

    
    assign abs_a = (a_sign == b_sign) ? a : {1'b0, a[N-2:0]};
    assign abs_b = (a_sign == b_sign) ? b : {1'b0, b[N-2:0]};

    always @(*) begin
        
        if (a_sign == b_sign) begin
            res = a - b;
        end
        
        else begin
            res = (a > b) ? abs_a + abs_b : abs_a - abs_b;
        end
    end

    
    always @(*) begin
        if (res == zero) begin
            c = {1'b0, {Q{1'b0}}};
 
        end else begin
            c = res;
        end
    end

endmodule
