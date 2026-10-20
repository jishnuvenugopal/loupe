
module fixed_point_adder #(
    parameter Q = 4,
    parameter N = 8
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;
    reg [N-2:0] res_mag;
    reg res_sign;

    a_sign = a[N-1];
    b_sign = b[N-1];

    
    a_mag = a_sign ? (~a + 1) : a;
    b_mag = b_sign ? (~b + 1) : b;

    if (a_sign == b_sign) begin
        
        res_mag = a_mag + b_mag;
        res_sign = a_sign;
    end else begin
        
        if (a_mag > b_mag) begin
            res_mag = a_mag - b_mag;
            res_sign = 0;
        end else if (b_mag > a_mag) begin
            res_mag = b_mag - a_mag;
            res_sign = 1;
        end else begin
            
            res_mag = 0;
            res_sign = 0;
        end
    end

    
    res = {res_sign, res_mag};
end

assign c = res;

endmodule
