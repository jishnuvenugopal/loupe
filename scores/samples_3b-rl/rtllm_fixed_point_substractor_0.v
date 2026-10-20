
module fixed_point_subtractor #(
    parameter integer Q = 8,   
    parameter integer N = 16  
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    
    wire [N-1:0] res;
    wire [N-1:0] a_int, a_frac, b_int, b_frac;
    wire [Q-1:0] a_frac_part, b_frac_part;
    wire [Q-1:0] res_frac;
    wire        a_sign, b_sign, res_sign;
    wire        a_pos, b_pos, res_pos;

    
    assign a_int = a[N-1:Q];
    assign a_frac = a[Q-1:0];
    assign b_int = b[N-1:Q];
    assign b_frac = b[Q-1:0];

    
    assign a_frac_part = a_frac[Q-1:0];
    assign b_frac_part = b_frac[Q-1:0];

    
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];

    
    assign res_sign = a_sign ^ b_sign;

    
    assign res_int = a_int - b_int;

    
    assign res_frac = a_frac_part - b_frac_part;

    
    assign res_frac = (res_frac == 0) ? {Q{1'b0}} : res_frac;

    
    assign res_pos = (a_pos && b_pos) || (a_pos && !b_pos && a_int > b_int) || (b_pos && !a_pos && b_int > a_int);

    
    assign res = {res_int, res_frac};

    
    always @(*) begin
        if (res == 0)
            c = {N{1'b0}};
        else
            c = res_sign ? {1'b1, res} : {1'b0, res};
    end

endmodule
