
module ring_counter(
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

    reg [7:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0000_0001;
        end else begin
            count <= count << 1;
            if (count == 8'b1000_0000) begin
                count <= 8'b0000_0001;
            end
        end
    end

    assign out = count;

endmodule
