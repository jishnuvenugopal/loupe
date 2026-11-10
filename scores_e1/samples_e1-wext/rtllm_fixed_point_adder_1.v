
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    
    reg [N-1:0] res;

    
    always @(*) begin
        if (a[Q] == b[Q]) begin
            res = a + b;
        end else if (a[Q] > b[Q]) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end

    
    always @(*) begin
        
        if (a[Q] == b[Q]) begin
            c = res;
        end else if (a[Q] > b[Q]) begin
            c = res;
        end else begin
            c = res;
        end
    end

    
    always @(*) begin
        
        if (res[Q] == 1'b1) begin
            
            c[Q] = 1'b0;
        end else begin
            c[Q] = res[Q];
        end
    end

endmodule
