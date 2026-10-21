
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

    
    parameter S = 10'b0000000001;
    parameter S1 = 10'b0000000010;
    parameter S11 = 10'b0000000100;
    parameter S110 = 10'b0000000101;
    parameter B0 = 10'b0000000110;
    parameter B1 = 10'b0000000111;
    parameter B2 = 10'b0000001000;
    parameter B3 = 10'b0000001001;
    parameter Count = 10'b0000001010;
    parameter Wait = 10'b0000001011;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S;
            B3_next <= 0;
            S_next <= 0;
            S1_next <= 0;
            Count_next <= 0;
            Wait_next <= 0;
            done <= 0;
            counting <= 0;
            shift_ena <= 0;
        end else begin
            case (state)
                S: begin
                    if (d == 1) begin
                        state <= S1;
                    end else if (done_counting == 1) begin
                        state <= Count;
                    end else if (ack == 0) begin
                        state <= Wait;
                    end
                end
                S1: begin
                    if (d == 1) begin
                        state <= S11;
                    end else if (done_counting == 1) begin
                        state <= Count;
                    end else if (ack == 0) begin
                        state <= Wait;
                    end
                end
                S11: begin
                    if (d == 1) begin
                        state <= S110;
                    end else if (done_counting == 1) begin
                        state <= Count;
                    end else if (ack == 0) begin
                        state <= Wait;
                    end
                end
                S110: begin
                    if (d == 1) begin
                        state <= S;
                    end else if (done_counting == 1) begin
                        state <= Count;
                    end else if (ack == 0) begin
                        state <= Wait;
                    end
                end
                B0: begin
                    B3_next <= 1;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 1;
                end
                B1: begin
                    B3_next <= 1;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 1;
                end
                B2: begin
                    B3_next <= 1;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 1;
                end
                B3: begin
                    B3_next <= 1;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 1;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 1;
                    shift_ena <= 1;
                end
                Count: begin
                    if (done_counting == 1) begin
                        state <= Wait;
                    end
                end
                Wait: begin
                    if (ack == 0) begin
                        state <= Wait;
                    end else if (done_counting == 1) begin
                        state <= S;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            B3_next <= 0;
            S_next <= 0;
            S1_next <= 0;
            Count_next <= 0;
            Wait_next <= 0;
            done <= 0;
            counting <= 0;
            shift_ena <= 0;
        end else begin
            case (state)
                S: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                S1: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                S11: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                S110: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                B0: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                B1: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                B2: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 0;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 0;
                    shift_ena <= 0;
                end
                B3: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 1;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 1;
                    shift_ena <= 1;
                end
                Count: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 1;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 1;
                    shift_ena <= 1;
                end
                Wait: begin
                    B3_next <= 0;
                    S_next <= 0;
                    S1_next <= 0;
                    Count_next <= 1;
                    Wait_next <= 0;
                    done <= 0;
                    counting <= 1;
                    shift_ena <= 1;
                end
            endcase
        end
    end

endmodule
