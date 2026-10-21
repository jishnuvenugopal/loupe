
module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

    
    typedef enum {S, S1, S11, S110, B0, B1, B2, B3, Count, Wait} state_t;

    
    state_t state_reg;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= S;
        end else begin
            case (state_reg)
                S: begin
                    if (d == 1) begin
                        state_reg <= S1;
                    end else if (done_counting == 1) begin
                        state_reg <= Count;
                    end else if (ack == 1) begin
                        state_reg <= Wait;
                    end
                end
                S1: begin
                    if (d == 1) begin
                        state_reg <= S11;
                    end else if (done_counting == 1) begin
                        state_reg <= Count;
                    end else if (ack == 1) begin
                        state_reg <= Wait;
                    end
                end
                S11: begin
                    if (d == 1) begin
                        state_reg <= S110;
                    end else if (done_counting == 1) begin
                        state_reg <= Count;
                    end else if (ack == 1) begin
                        state_reg <= Wait;
                    end
                end
                S110: begin
                    if (d == 1) begin
                        state_reg <= S;
                    end else if (done_counting == 1) begin
                        state_reg <= Count;
                    end else if (ack == 1) begin
                        state_reg <= Wait;
                    end
                end
                B0: begin
                    if (shift_ena == 1) begin
                        state_reg <= B1;
                    end
                end
                B1: begin
                    if (shift_ena == 1) begin
                        state_reg <= B2;
                    end
                end
                B2: begin
                    if (shift_ena == 1) begin
                        state_reg <= B3;
                    end
                end
                B3: begin
                    if (shift_ena == 1) begin
                        state_reg <= Count;
                    end
                end
                Count: begin
                    if (!done_counting) begin
                        state_reg <= Count;
                    end else if (ack == 1) begin
                        state_reg <= Wait;
                    end
                end
                Wait: begin
                    if (ack == 0) begin
                        state_reg <= Wait;
                    end else if (ack == 1) begin
                        state_reg <= S;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge rst) begin
        case (state_reg)
            S: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            S1: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            S11: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            S110: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            B0: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            B1: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            B2: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            B3: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            Count: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
            Wait: begin
                B3_next <= 1'b0;
                S_next <= 1'b0;
                S1_next <= 1'b0;
                Count_next <= 1'b0;
                Wait_next <= 1'b0;
                done <= 1'b0;
                counting <= 1'b0;
                shift_ena <= 1'b0;
            end
        endcase
    end

endmodule
