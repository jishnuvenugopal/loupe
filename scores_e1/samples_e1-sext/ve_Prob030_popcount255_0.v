
module TopModule (
    input wire [254:0] in,
    output reg [7:0] out
);

    reg [7:0] pop_count;

    always @(*) begin
        pop_count = 0;
        for (int i = 0;
 i < 255;
 i = i + 1) begin
            if (in[i]) begin
                pop_count = pop_count + 1;
            end
        end
        out = pop_count;
    end

endmodule
