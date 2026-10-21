
module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        if (ar) begin
            state <= 2'b00;
 
        end else if (clk) begin
            state <= state + 1'b1;
 
        end
    end

    
    always @(posedge clk) begin
        if (ar) begin
            q <= 1'b0;
 
        end else if (clk) begin
            q <= state;
 
        end
    end

endmodule
