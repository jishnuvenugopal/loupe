
module TopModule (
    input  wire d,
    input  wire done_counting,
    input  wire ack,
    input  wire [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

    
    reg [9:0] next_state;

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                if (d == 1'b0) next_state = 10'b0000000001;
 
                else next_state = 10'b0000000010;
 
            end
            10'b0000000010: begin 
                if (d == 1'b0) next_state = 10'b0000000001;
 
                else next_state = 10'b0000000100;
 
            end
            10'b0000000100: begin 
                if (d == 1'b0) next_state = 10'b0000000100;
 
                else next_state = 10'b0000001000;
 
            end
            10'b0000001000: begin 
                if (d == 1'b0) next_state = 10'b0000001000;
 
                else next_state = 10'b0000010000;
 
            end
            10'b0000010000: begin 
                next_state = 10'b0000010001;
 
            end
            10'b0000010001: begin 
                next_state = 10'b0000010010;
 
            end
            10'b0000010010: begin 
                next_state = 10'b0000010011;
 
            end
            10'b0000010011: begin 
                next_state = 10'b0000010100;
 
            end
            10'b0000010100: begin 
                if (done_counting == 1'b0) next_state = 10'b0000010100;
 
                else next_state = 10'b0000010101;
 
            end
            10'b0000010101: begin 
                if (ack == 1'b0) next_state = 10'b0000010101;
 
                else next_state = 10'b0000000001;
 
            end
            default: next_state = 10'b0000000001;
 
        endcase
    end

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                B3_next = 1'b0;
                S_next = 1'b1;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000010: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b1;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000100: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000001000: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010000: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010001: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010010: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010011: begin 
                B3_next = 1'b1;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            10'b0000010100: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            10'b0000010101: begin 
                B3_next = 1'b0;
                S_next = 1'b0;
                S1_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b1;
                done = ack;
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

    
    always @(posedge d or posedge done_counting or posedge ack or posedge state) begin
        if (d || done_counting || ack || state) begin
            state <= next_state;
        end
    end

endmodule
