
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  state [9:0], 
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    
    localparam S = 10'b0000000001;
    localparam S1 = 10'b0000000010;
    localparam S11 = 10'b0000000100;
    localparam S110 = 10'b0000000101;
    localparam B0 = 10'b0000000110;
    localparam B1 = 10'b0000000111;
    localparam B2 = 10'b0000001000;
    localparam B3 = 10'b0000001001;
    localparam Count = 10'b0000001010;
    localparam Wait = 10'b0000001011;

    
    always_comb begin
        case (state)
            S: begin
                B3_next = 1'b0;
                S_next = d ? S1 : S;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S1: begin
                B3_next = 1'b0;
                S_next = d ? S11 : S;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S11: begin
                B3_next = 1'b0;
                S_next = d ? S110 : S;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S110: begin
                B3_next = 1'b0;
                S_next = d ? S : S;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            B0: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B1: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B2: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B3: begin
                B3_next = 1'b1;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            Count: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = done_counting;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            Wait: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            default: begin
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
        endcase
    end

    
    always_comb begin
        done = done_counting;
        counting = shift_ena;
        shift_ena = (state == B0) ? 1'b1 : 1'b0;
    end

endmodule
