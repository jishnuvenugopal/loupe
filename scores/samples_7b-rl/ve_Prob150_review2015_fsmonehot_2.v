
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

    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[7:4];
 

    
    assign S_next = state[0] & ~d;
    assign S1_next = state[1] & ~d;
    assign S11_next = state[2] & d;
    assign S110_next = state[2] & ~d;
    assign B0_next = state[3] & d;
    assign B1_next = state[4];
    assign B2_next = state[5];
    assign B3_next = state[6];
    assign Count_next = state[5] | (state[7] & ~state[8]);
    assign Wait_next = (state[8] & done_counting) | (state[9] & ack);

endmodule
