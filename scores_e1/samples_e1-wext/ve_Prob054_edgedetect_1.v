
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] transition_count;
    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;

        if (prev_in == 8'b0 && in == 8'b1) begin
            transition_count <= transition_count + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (transition_count == 1'b1) begin
            pedge <= 8'b1;
            transition_count <= 8'b0;
        end
    end

endmodule
