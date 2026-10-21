
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    
    reg [9:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    
    assign q = counter;

endmodule
