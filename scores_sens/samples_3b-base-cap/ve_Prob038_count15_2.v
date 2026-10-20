
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    
    reg [3:0] counter;

    
    reg counter_enable;

    
    always @(posedge reset) begin
        counter <= 4'b0;
        counter_enable <= 1'b0;
    end

    
    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= counter + 1'b1;
        end
    end

    
    assign q = counter;

endmodule
