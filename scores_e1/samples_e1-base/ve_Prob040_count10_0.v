
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] counter;
    reg [0:0] reset_reg;
    reg [0:0] clk_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_reg <= 1'b1;
            counter <= 4'b0000;
        end else begin
            reset_reg <= 1'b0;
            clk_reg <= 1'b1;
            if (clk_reg) begin
                counter <= counter + 1'b1;
                if (counter == 4'b1001) begin
                    counter <= 4'b0000;
                end
            end
        end
    end

    assign q = counter;

endmodule
