
module fixed_point_adder #(
    parameter Q = 8,
    parameter N = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;

    always @(*) begin
        
        if (a[N-1] == b[N-1]) begin
            
            res = a + b;
            if (res[N-1] != a[N-1]) begin
                
                if (a[N-1] == 1'b0) begin
                    
                    res = {1'b0, {(N-1){1'b1}}};
                end else begin
                    
                    res = {1'b1, {(N-1){1'b0}}};
                end
            end
        end else begin
            
            reg [N-1:0] diff, abs_diff;
            diff = a - b;
            if (diff[N-1] == 1'b0) begin
                
                res = diff;
            end else begin
                
                abs_diff = -diff;
                
                if (abs_diff > ((1 << (N-1)) - 1)) begin
                    res = {1'b0, {(N-1){1'b1}}};
                end else begin
                    res = abs_diff;
                end
            end
        end
        c = res;
    end

endmodule
