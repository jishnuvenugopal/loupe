
module TopModule(
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


parameter S = 10'b0000000001;
parameter S1 = 10'b0000000010;
parameter S11 = 10'b0000000100;
parameter S110 = 10'b0000001000;
parameter B0 = 10'b0000010000;
parameter B1 = 10'b0000100000;
parameter B2 = 10'b0001000000;
parameter B3 = 10'b0010000000;
parameter Count = 10'b0100000000;
parameter Wait = 10'b1000000000;


always @(*) begin
    B3_next = state;
    S_next = state;
    S1_next = state;
    Count_next = state;
    Wait_next = state;

    case (state)
        S: begin
            if (d)
                S1_next = S1;
        end
        S1: begin
            if (d)
                S11_next = S11;
            else
                S_next = S;
        end
        S11: begin
            if (d)
                S11_next = S11;
            else
                S1_next = S;
        end
        S110: begin
            if (d)
                B0_next = B0;
            else
                S_next = S;
        end
        B0: B1_next = B1;
        B1: B2_next = B2;
        B2: B3_next = B3;
        B3: Count_next = Count;
        Count: begin
            if (!done_counting)
                Wait_next = Wait;
            else
                Count_next = Count;
        end
        Wait: begin
            if (ack == 0)
                Wait_next = Wait;
            else
                S_next = S;
        end
    endcase
end


always @(*) begin
    done = 0;
    counting = 0;
    shift_ena = 0;

    case (state)
        Count: counting = 1;
        Wait: done = 1;
        B3: shift_ena = 1;
        B2: shift_ena = 1;
        B1: shift_ena = 1;
        B0: shift_ena = 1;
    endcase
end

endmodule
