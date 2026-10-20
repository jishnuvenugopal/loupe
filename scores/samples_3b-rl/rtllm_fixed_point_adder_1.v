
module fixed_point_adder #(
    parameter integer Q = 4, 
    parameter integer N = 8  
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    
    reg [N-1:0] res;
    wire [N-1:0] a_abs, b_abs;
    wire [N-1:0] a_mag, b_mag;
    wire [N-1:0] a_sign, b_sign;
    wire        a_gt_b;

    
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag  = { {N-Q-1{1'b0}}, a[Q-1:0] };
    assign b_mag  = { {N-Q-1{1'b0}}, b[Q-1:0] };

    
    assign a_abs = (a_sign == b_sign) ? a_mag : a_mag;
    assign b_abs = (a_sign == b_sign) ? b_mag : b_mag;

    
    assign a_gt_b = (a_abs > b_abs);

    
    always @(*) begin
        if (a_sign == b_sign) begin
            
            res = a_abs + b_abs;
        end else begin
            if (a_gt_b) begin
                
                res = a_abs - b_abs;
            end else begin
                
                res = b_abs - a_abs;
            end
        end
        
        res[N-1] = a_sign;
    end

    
    assign c = res;

endmodule
