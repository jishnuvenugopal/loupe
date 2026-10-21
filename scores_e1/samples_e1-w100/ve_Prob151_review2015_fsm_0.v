
module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    
    typedef enum {Idle, Counting, Done} state_t;
    state_t state;

    
    reg [3:0] duration_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            duration_count <= 4'b0000;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                Idle: begin
                    if (data == 4'b1101) begin
                        state <= Counting;
                        duration_count <= 4'b0000;
                    end
                end
                Counting: begin
                    duration_count <= duration_count + 1'b1;
                    if (duration_count == 4'b1111) begin
                        state <= Done;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                Done: begin
                    if (done_counting == 1'b1) begin
                        state <= Idle;
                        done_counting <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    assign shift_ena = state == Counting;
    assign counting = state == Counting;
    assign done = state == Done;

endmodule
