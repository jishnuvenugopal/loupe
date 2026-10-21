
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 10'b0;
 
        end else begin
            if (counter < 10'b999) begin
                counter <= counter + 1'b1;
 
            end
        end
    end

    assign q = counter;
 

endmodule
