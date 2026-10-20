
module TopModule (clk, reset, q);
    input wire clk;
    input wire reset;
    output reg [3:0] q;

    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            if (counter == 4'b1001) begin
                counter <= 4'b0000;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(*) begin
        q = counter;
    end

endmodule
