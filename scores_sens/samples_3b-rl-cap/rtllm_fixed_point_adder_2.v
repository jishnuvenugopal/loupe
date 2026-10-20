
module fixed_point_adder #(
    parameter integer Q = 8,   
    parameter integer N = 16  
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    
    wire [N-1:0] a_abs, b_abs;
    wire [N-1:0] a_int, a_frac, b_int, b_frac;
    wire        a_sign, b_sign;
    wire        a_larger, b_larger;
    wire        same_sign;
    wire        overflow;

    
    assign a_sign  = a[N-1];
    assign b_sign  = b[N-1];

    
    assign a_int  = a[N-1-Q-1:0];
    assign a_frac = a[N-1:Q+1];
    assign a_abs  = {a_sign, a_int} + {a_sign, a_frac};

    
    assign b_int  = b[N-1-Q-1:0];
    assign b_frac = b[N-1:Q+1];
    assign b_abs  = {b_sign, b_int} + {b_sign, b_frac};

    
    assign a_larger = (a_abs[N-1] == a_sign) && (b_abs[N-1] != a_sign) ? 1'b1 : 1'b0;
    assign b_larger = (b_abs[N-1] == b_sign) && (a_abs[N-1] != b_sign) ? 1'b1 : 1'b0;
    assign same_sign = a_sign == b_sign;

    
    reg [N-1:0] res;
    always @(*) begin
        if (same_sign) begin
            
            res = a_abs + b_abs;
        end else if (a_larger) begin
            
            res = a_abs - b_abs;
        end else begin
            
            res = b_abs - a_abs;
        end
    end

    
    assign overflow = res[N-1] != a[N-1] && res[N-1] != b[N-1];

    
    always @(*) begin
        if (overflow) begin
            c = {N{1'b0}};
        end else begin
            c = res;
        end
    end

endmodule
