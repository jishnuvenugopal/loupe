
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] out
);

    reg [7:0] prev_in, prev_prev_in;
    reg [7:0] out_next;

    always @(posedge clk) begin
        prev_prev_in <= prev_in;
        prev_in <= in;

        out_next = out;

        
        for (integer i = 0;
 i < 8;
 i = i + 1) begin
            if (prev_in[i] == 0 && in[i] == 1 && anyedge[i] == 1) begin
                out_next[i] <= 1;
            end
        end

        
        for (integer i = 0;
 i < 8;
 i = i + 1) begin
            if (prev_in[i] == 1 && in[i] == 0 && anyedge[i] == 1) begin
                out_next[i] <= 1;
            end
        end
    end

    assign out = out_next;

endmodule
