
module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output S11_next,
    output S110_next,
    output B0_next,
    output B1_next,
    output B2_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    
    assign S_next = (state[0] & ~d) | (state[1] & ~d) | (state[2] & ~d) | (state[3] & ~d);

    
    assign S1_next = (state[0] & d) | (state[1] & d);

    
    assign S11_next = state[2] & d;

    
    assign S110_next = state[3] & d;

    
    assign B0_next = state[3];
 
    assign B1_next = state[4];
 
    assign B2_next = state[5];
 
    assign B3_next = state[6];
 

    
    assign Count_next = state[8] & ~done_counting;

    
    assign Wait_next = (state[9] & ~ack) | (state[8] & done_counting);

    
    assign done = state[9];
    assign counting = state[8];
    assign shift_ena = |state[4:7];
 

endmodule
