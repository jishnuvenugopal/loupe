
module TopModule (
    input d, done_counting, ack,
    input [9:0] state,
    output B3_next, S_next, S1_next, S11_next, S110_next, B0_next, B1_next, B2_next,
    output Count_next, Wait_next,
    output done, counting, shift_ena
);
    
    localparam S        = 10'b0000000001;
    localparam S1       = 10'b0000000010;
    localparam S11      = 10'b0000000100;
    localparam S110     = 10'b0000001000;
    localparam B0       = 10'b0000010000;
    localparam B1       = 10'b0000100000;
    localparam B2       = 10'b0001000000;
    localparam B3       = 10'b0010000000;
    localparam Count    = 10'b0100000000;
    localparam Wait     = 10'b1000000000;

    
    
    assign S_next = (state == S && ~d) ? 1 : ((state == S110 && ~d) ? 1 : 0);

    
    assign S1_next = (state == S1 && ~d) ? S : ((state == S1 && d) ? S11 : 0);

    
    assign S11_next = (state == S11 && ~d) ? S110 : ((state == S11 && d) ? S11 : 0);

    
    assign S110_next = (state == S110 && ~d) ? S : ((state == S110 && d) ? B0 : 0);

    
    assign B0_next = (state == B0) ? B1 : 0;

    
    assign B1_next = (state == B1) ? B2 : 0;

    
    assign B2_next = (state == B2) ? B3 : 0;

    
    assign B3_next = (state == B3) ? Count : 0;

    
    assign Count_next = (state == Count) ? (done_counting ? Wait : Count) : 0;

    
    assign Wait_next = (state == Wait) ? (ack ? S : Wait) : 0;

    
    assign done = (state == Wait);
    assign counting = (state == Count);
    assign shift_ena = (state == B0 || state == B1 || state == B2 || state == B3);

endmodule
