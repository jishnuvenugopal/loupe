
module TopModule (
    input wire clk,
    input wire a,
    output reg p,
    output reg q
);

    
    reg prev_a;

    
    initial begin
        p = 0;
        q = 0;
    end

    
    always @(posedge clk) begin
        
        prev_a <= a;

        
        if (a == 1) begin
            p = 1;
            q = 0;
        end else begin
            p = 0;
            q = prev_a;
        end
    end

endmodule
