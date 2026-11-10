
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;
    reg reset_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
            reset_state <= 1'b1;
        end else begin
            if (reset_state) begin
                count <= 4'b0000;
                reset_state <= 1'b0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    assign q = count;

endmodule
