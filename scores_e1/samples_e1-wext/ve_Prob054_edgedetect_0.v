
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] transition_count;
    reg [7:0] last_in;

    always @(posedge clk) begin
        if (in != last_in) begin
            transition_count <= transition_count + 1;
            last_in <= in;
        end else begin
            transition_count <= transition_count;
        end
    end

    always @(posedge clk) begin
        if (transition_count == 1) begin
            pedge <= 1'b1;
            transition_count <= 0;
        end else begin
            pedge <= 1'b0;
        end
    end

endmodule
