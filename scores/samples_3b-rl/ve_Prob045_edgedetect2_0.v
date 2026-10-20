
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] out
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        
        if (in[0] && !prev_in[0])
            out[0] <= 1'b1;
        else
            out[0] <= 1'b0;

        if (in[1] && !prev_in[1])
            out[1] <= 1'b1;
        else
            out[1] <= 1'b0;

        if (in[2] && !prev_in[2])
            out[2] <= 1'b1;
        else
            out[2] <= 1'b0;

        if (in[3] && !prev_in[3])
            out[3] <= 1'b1;
        else
            out[3] <= 1'b0;

        if (in[4] && !prev_in[4])
            out[4] <= 1'b1;
        else
            out[4] <= 1'b0;

        if (in[5] && !prev_in[5])
            out[5] <= 1'b1;
        else
            out[5] <= 1'b0;

        if (in[6] && !prev_in[6])
            out[6] <= 1'b1;
        else
            out[6] <= 1'b0;

        if (in[7] && !prev_in[7])
            out[7] <= 1'b1;
        else
            out[7] <= 1'b0;

        
        prev_in <= in;
    end

endmodule
