
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
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

    
    always @(*) begin
        case (state)
            S: begin
                if (d == 0) S_next = S;
                else if (d == 1) S_next = S1;
            end
            S1: begin
                if (d == 0) S_next = S;
                else if (d == 1) S_next = S11;
            end
            S11: begin
                if (d == 0) S_next = S;
                else if (d == 1) S_next = S110;
            end
            S110: begin
                if (d == 0) S_next = S;
                else if (d == 1) S_next = B0;
            end
            B0: begin
                B3_next = 1'b1;
                S_next = B1;
            end
            B1: begin
                B3_next = 1'b1;
                S_next = B2;
            end
            B2: begin
                B3_next = 1'b1;
                S_next = B3;
            end
            B3: begin
                B3_next = 1'b1;
                Count_next = 1'b1;
            end
            Count: begin
                if (!done_counting) Count_next = 1'b1;
                else Wait_next = 1'b1;
            end
            Wait: begin
                if (ack == 0) Wait_next = 1'b1;
                else S_next = S;
            end
            default: begin
                S_next = S;
 
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            S: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S1: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S11: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            S110: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            B0: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B1: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B2: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            B3: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            Count: begin
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            Wait: begin
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            default: begin
                done = 1'b0;
 
                counting = 1'b0;
 
                shift_ena = 1'b0;
 
            end
        endcase
    end

endmodule
