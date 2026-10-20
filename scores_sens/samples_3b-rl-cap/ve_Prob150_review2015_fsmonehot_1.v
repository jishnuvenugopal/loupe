
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

    
    reg [9:0] state_reg;

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    S1_next = 1'b1;
            end
            10'b0000000010: begin 
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    S11_next = 1'b1;
            end
            10'b0000000100: begin 
                if (d == 1'b0)
                    S1_next = 1'b1;
                else
                    S11_next = 1'b1;
            end
            10'b0000001000: begin 
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    B0_next = 1'b1;
            end
            10'b0000010000: begin 
                B3_next = 1'b1;
            end
            10'b0000100000: begin 
                B3_next = 1'b1;
            end
            10'b0001000000: begin 
                B3_next = 1'b1;
            end
            10'b0010000000: begin 
                if (done_counting == 1'b0)
                    Count_next = 1'b1;
                else
                    Wait_next = 1'b1;
            end
            10'b0100000000: begin 
                if (ack == 1'b0)
                    Wait_next = 1'b1;
                else
                    S_next = 1'b1;
            end
            10'b1000000000: begin 
                
            end
            default: begin
                S_next = 1'b1;
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000010: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000000100: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000001000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b0;
            end
            10'b0000010000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            10'b0000100000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            10'b0001000000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            10'b0010000000: begin 
                done = 1'b0;
                counting = 1'b0;
                shift_ena = 1'b1;
            end
            10'b0100000000: begin 
                done = 1'b0;
                counting = 1'b1;
                shift_ena = 1'b0;
            end
            10'b1000000000: begin 
                done = 1'b1;
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

    
    always @(*) begin
        case (state)
            10'b0000000001: begin 
                if (d == 1'b0)
                    state_reg = 10'b0000000001;
                else
                    state_reg = 10'b0000000010;
            end
            10'b0000000010: begin 
                if (d == 1'b0)
                    state_reg = 10'b0000000010;
                else
                    state_reg = 10'b0000000100;
            end
            10'b0000000100: begin 
                if (d == 1'b0)
                    state_reg = 10'b0000000100;
                else
                    state_reg = 10'b0000001000;
            end
            10'b0000001000: begin 
                if (d == 1'b0)
                    state_reg = 10'b0000001000;
                else
                    state_reg = 10'b0000010000;
            end
            10'b0000010000: begin 
                state_reg = 10'b0000100000;
            end
            10'b0000100000: begin 
                state_reg = 10'b0001000000;
            end
            10'b0001000000: begin 
                state_reg = 10'b0010000000;
            end
            10'b0010000000: begin 
                state_reg = 10'b0100000000;
            end
            10'b0100000000: begin 
                state_reg = 10'b1000000000;
            end
            10'b1000000000: begin 
                state_reg = 10'b0000000001;
            end
            default: begin
                state_reg = 10'b0000000001;
            end
        endcase
    end

    
    assign state = state_reg;

endmodule
