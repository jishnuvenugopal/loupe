
module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);


assign S_next = state[9] ? (d == 1'b0) : state[9];
assign S1_next = state[9] ? ((d == 1'b0) ? (state[8] ? 10'b0000000100 : 10'b0000000000) : (state[8] ? 10'b0000000110 : 10'b0000000100)) : state[9];
assign Count_next = (state[5] || state[6] || state[7] || state[8]) && !done_counting ? state[5] : (state[1] && done_counting ? state[0] : state[1]);
assign Wait_next = (state[1] && done_counting) && ack ? state[0] : state[1];
assign B3_next = (state[1] && done_counting) && ack ? state[9] : state[1];


assign done = state[0];
assign counting = (state[5] || state[6] || state[7] || state[8]);
assign shift_ena = (state[1] && done_counting) && ack || (state[9] && (state[1] || (state[6] && !done_counting)));

endmodule
