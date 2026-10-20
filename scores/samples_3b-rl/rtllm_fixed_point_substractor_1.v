
module fixed_point_subtractor #(
    parameter integer Q = 8, 
    parameter integer N = 16 
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    
    reg [N-1:0] res;

    
    wire [N-1:0] a_ext = {a[N-1], a[N-Q-1:0]};
    wire [N-1:0] b_ext = {b[N-1], b[N-Q-1:0]};

    always @(*) begin
        
        wire a_sign = a[N-1];
        wire b_sign = b[N-1];

        
        if (a_sign == b_sign) begin
            res = a_ext - b_ext;
        end
        
        else begin
            res = a_ext + (~b_ext + 1'b1);
 
        end

        
        if (res == 0) begin
            res = {N{1'b0}};
 
        end

        
        c = res;
    end

endmodule
