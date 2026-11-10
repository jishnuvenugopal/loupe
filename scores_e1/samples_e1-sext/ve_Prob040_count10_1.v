
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
            counter <= 2'b00;
        end else begin
            if (counter == 2'b11) begin
                count <= 4'b0000;
                counter <= 2'b00;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

    assign q = count;

endmodule
