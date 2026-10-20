
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] q_reg;
    wire [511:0] next_state;

    assign q = q_reg;

    generate
        genvar i;
        for (i = 0;
 i < 512;
 i = i + 1) begin : gen_next
            wire left = (i == 0) ? 1'b0 : q_reg[i-1];
            wire right = (i == 511) ? 1'b0 : q_reg[i+1];
            wire current = q_reg[i];

            assign next_state[i] = 
                ( {left, current, right} == 3'b111 ) ? 1'b0 :
                ( {left, current, right} == 3'b110 ) ? 1'b1 :
                ( {left, current, right} == 3'b101 ) ? 1'b1 :
                ( {left, current, right} == 3'b100 ) ? 1'b0 :
                ( {left, current, right} == 3'b011 ) ? 1'b1 :
                ( {left, current, right} == 3'b010 ) ? 1'b1 :
                ( {left, current, right} == 3'b001 ) ? 1'b1 :
                1'b0;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_state;
    end

endmodule
