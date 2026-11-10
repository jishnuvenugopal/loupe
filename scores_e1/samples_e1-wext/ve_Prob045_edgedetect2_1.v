
module TopModule (
    input clk,
    input in,
    input anyedge,
    output reg [7:0] out
);

    reg [7:0] transition_count;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        transition_count <= 8'b0;
        edge_detected <= 8'b0;

        for (int i = 0;
 i < 8;
 i++) begin
            if (in[i] != anyedge[i]) begin
                transition_count[i] <= transition_count[i] + 1'b1;
                if (transition_count[i] == 1'b1) begin
                    edge_detected[i] <= 1'b1;
                end
            end
        end
    end

    assign out = edge_detected;

endmodule
