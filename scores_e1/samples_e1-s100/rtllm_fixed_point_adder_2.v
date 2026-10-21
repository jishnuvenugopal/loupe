
module fixed_point_adder (
    input wire [N-1:0] a,  
    input wire [N-1:0] b,  
    output reg [N-1:0] c   
);

    
    parameter Q = 8;

    
    parameter N = Q + 1;

    
    reg [N-1:0] res;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            res <= 0;
        end else begin
            if (a[Q] == b[Q]) begin
                res <= a + b;
            end else if (a[Q] > b[Q]) begin
                res <= a - b;
            end else begin
                res <= b - a;
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            c <= 0;
        end else begin
            if (res[Q] == 1) begin
                c <= res + 1;
            end else begin
                c <= res;
            end
        end
    end

endmodule
