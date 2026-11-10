
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    
    reg [3:0] counter;
    reg [1:0] jk;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            jk <= 2'b00;
        end else begin
            jk <= counter[3];
            counter <= counter + 1'b1;
        end
    end

    
    assign q = counter;

endmodule
