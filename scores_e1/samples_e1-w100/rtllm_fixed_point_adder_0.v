
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    
    reg [N-1:0] res;

    
    parameter Q = 8;
 
    parameter N = 16;
 

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            res <= 0;
        end else begin
            if (a[Q-1] == b[Q-1]) begin
                res <= a + b;
            end else if (a[Q-1] > b[Q-1]) begin
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
            c <= res;
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            c <= 0;
        end else begin
            if (res[Q] == 1) begin
                c <= 0;
            end else begin
                c <= res;
            end
        end
    end

endmodule
