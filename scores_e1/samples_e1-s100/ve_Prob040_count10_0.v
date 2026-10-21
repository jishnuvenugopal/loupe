
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    reg [3:0] counter;
    reg [0:0] reset_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            reset_reg <= 1'b1;
        end else begin
            if (reset_reg == 1'b1) begin
                reset_reg <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (counter == 4'b0101) begin
            counter <= 4'b0000;
        end
    end

    assign q = counter;

endmodule
