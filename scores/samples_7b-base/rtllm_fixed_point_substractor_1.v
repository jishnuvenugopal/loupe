
module fixed_point_subtractor #(parameter Q = 8, parameter N = Q + 1)(input [N-1:0] a, input [N-1:0] b, output [N-1:0] c);

    reg [N-1:0] res;

    always @(*) begin
        if (a[N-1] == b[N-1]) begin  
            res = a - b;
            
            if (res == 0) begin
                res[N-1] = 0;
            end
        end else begin  
            if (a[N-1] == 1) begin  
                res = a + (~b + 1);
                if (a > b) begin
                    res[N-1] = 1;
                end else begin
                    res[N-1] = 0;
                end
            end else begin  
                res = b + (~a + 1);
                if (b > a) begin
                    res[N-1] = 1;
                end else begin
                    res[N-1] = 0;
                end
            end
        end
    end

    assign c = res;

endmodule
