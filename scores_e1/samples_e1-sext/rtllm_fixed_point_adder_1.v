
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

parameter N = 16;
 

reg [N-1:0] res;
 

always @(*) begin
    
    if (a[Q] == b[Q]) begin
        res = a + b;
    end else if (a[Q] > b[Q]) begin
        res = a - b;
    end else begin
        res = b - a;
    end

    
    if (res[Q] == 1'b1) begin
        
        if (a[Q] == 1'b1 && b[Q] == 1'b1) begin
            
            if (a[Q-1] == 1'b1 && b[Q-1] == 1'b1) begin
                
                c = 1'b1;
            end else begin
                
                c = 1'b0;
            end
        end else if (a[Q] == 1'b0 && b[Q] == 1'b0) begin
            
            if (a[Q-1] == 1'b0 && b[Q-1] == 1'b0) begin
                
                c = 1'b0;
            end else begin
                
                c = 1'b1;
            end
        end
    end

    
    if (a[Q] == b[Q]) begin
        c[Q] = a[Q];
    end else if (a[Q] > b[Q]) begin
        c[Q] = 1'b0;
    end else begin
        c[Q] = 1'b1;
    end
end

endmodule
