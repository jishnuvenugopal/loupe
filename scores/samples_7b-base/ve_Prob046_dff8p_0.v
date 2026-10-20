
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [7:0] dff_outputs;

    
    integer i;
    generate
        for (i = 0;
 i < 8;
 i = i + 1) begin : dffs
            dff dx (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(dff_outputs[i])
            );
        end
    endgenerate

    
    assign q = dff_outputs;

    
    module dff (
        input clk,
        input reset,
        input d,
        output reg q
    );
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                q <= 8'b00110100;
            end else begin
                q <= d;
            end
        end
    endmodule

endmodule
