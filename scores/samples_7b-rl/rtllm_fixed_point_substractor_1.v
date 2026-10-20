
module fixed_point_subtractor #(
    parameter Q = 16,
    parameter N = 32
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

    reg [N-1:0] res;

    
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    
    wire [N-1:0] mag_a = sign_a ? (~a + 1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1) : b;

    
    reg result_sign;
    reg [N-1:0] result_mag;

    always @* begin
        if (sign_a == sign_b) begin
            
            if (mag_a >= mag_b) begin
                result_mag = mag_a - mag_b;
                result_sign = sign_a;
            end else begin
                result_mag = mag_b - mag_a;
                result_sign = sign_a;
            end
        end else begin
            
            if (mag_a > mag_b) begin
                result_mag = mag_a - mag_b;
                result_sign = sign_a;
            end else if (mag_b > mag_a) begin
                result_mag = mag_b - mag_a;
                result_sign = sign_b;
            end else begin 
                result_mag = 0;
                result_sign = 0;
            end
        end

        
        if (result_mag == 0)
            result_sign = 0;

        res = {result_sign, result_mag};
    end

    assign c = res;

endmodule
