
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state;

    
    reg [2:0] w_counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            w_counter <= 3'b000;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_counter <= 3'b000;
                    end
                end
                B: begin
                    if (w) begin
                        w_counter <= w_counter + 1'b1;
                    end else begin
                        w_counter <= 3'b000;
                    end
                    if (w_counter == 3'b111) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                end
                default: begin
                    state <= A;
                    w_counter <= 3'b000;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule
