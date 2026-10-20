
module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output [9:0] B3_next,
    output [9:0] S_next,
    output [9:0] S1_next,
    output [9:0] Count_next,
    output [9:0] Wait_next,
    output done,
    output counting,
    output shift_ena
);

    
    assign S_next    = (state[0]) ? (d ? 10'b0000000010 : 10'b0000000001) : 10'b0;
    assign S1_next   = (state[1]) ? (d ? 10'b0000000100 : 10'b0000000001) : 10'b0;
    assign S11_next  = (state[2]) ? (d ? 10'b0000000100 : 10'b0000001000) : 10'b0;
    assign S110_next = (state[3]) ? (d ? 10'b0000010000 : 10'b0000000001) : 10'b0;
    assign B0_next   = (state[4]) ? 10'b0000100000 : 10'b0;
    assign B1_next   = (state[5]) ? 10'b0001000000 : 10'b0;
    assign B2_next   = (state[6]) ? 10'b0010000000 : 10'b0;
    assign B3_next   = (state[7]) ? 10'b0100000000 : 10'b0;
    assign Count_next= (state[8]) ? (done_counting ? 10'b1000000000 : 10'b0100000000) : 10'b0;
    assign Wait_next = (state[9]) ? (ack ? 10'b0000000001 : 10'b1000000000) : 10'b0;

    
    assign done      = state[9];
    assign counting  = state[8];
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule
