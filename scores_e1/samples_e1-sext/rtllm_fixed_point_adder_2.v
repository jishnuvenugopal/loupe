
module fixed_point_adder (
    input wire [N-1:0] a,  
    input wire [N-1:0] b,  
    output reg [N-1:0] c   
);

    parameter Q = 8;
  
    parameter N = 16;
  

    reg [N-1:0] res;
  

    always @(*) begin
        
        reg [1:0] sign = (a[Q] == b[Q]) ? 2'b00 : (a[Q] > b[Q]) ? 2'b01 : 2'b10;

        
        if (a[Q] == b[Q]) begin
            res = a + b;
        end else if (a[Q] > b[Q]) begin
            res = a - b;
        end else begin
            res = b - a;
        end

        
        if (res[Q] == 1'b1) begin
            if (sign == 2'b00) begin
                res = res - 2'b10000000;
  
            end else begin
                res = res + 2'b10000000;
  
            end
        end

        
        c = res;
    end

endmodule
