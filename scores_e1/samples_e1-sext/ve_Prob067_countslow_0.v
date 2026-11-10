
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    
    reg [3:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else if (slowena) begin
            counter <= counter + 1;
        end
    end

    
    assign q = counter;

endmodule
