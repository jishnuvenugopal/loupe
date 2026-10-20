
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  state [9:0],
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

always @(*) begin
    
    if (state == 10'b0000000001) begin 
        S_next = (state & ~d) | (state & d);
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = state;
    end else if (state == 10'b0000000010) begin 
        S_next = (state & ~d) | (state & d);
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = state;
    end else if (state == 10'b0000000100) begin 
        S_next = (state & ~d) | (state & d);
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = state;
    end else if (state == 10'b0000001000) begin 
        S_next = (state & ~d) | (state & d);
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = state;
    end else if (state == 10'b0000010000) begin 
        S_next = state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = 1;
    end else if (state == 10'b0000100000) begin 
        S_next = state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = 1;
    end else if (state == 10'b0001000000) begin 
        S_next = state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = state;
        shift_ena = 1;
    end else if (state == 10'b0010000000) begin 
        S_next = state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = state;
        counting = 1;
        shift_ena = 1;
    end else if (state == 10'b0100000000) begin 
        S_next = (Wait & ~done_counting) | state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = done_counting;
        counting = done_counting;
        shift_ena = state;
    end else if (state == 10'b1000000000) begin 
        S_next = (state & ~ack) | state;
        B3_next = state;
        S1_next = state;
        Count_next = state;
        Wait_next = state;
        done = ack;
        counting = state;
        shift_ena = state;
    end
end

endmodule
