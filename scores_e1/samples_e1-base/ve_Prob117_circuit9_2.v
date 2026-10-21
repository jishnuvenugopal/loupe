
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    
    reg [1:0] state;

    
    always @(posedge clk or posedge a) begin
        if (a == 0) begin
            state <= 0;
        end else begin
            state <= 1;
        end
    end

    
    always @(posedge clk) begin
        q <= ~state;
    end

endmodule
