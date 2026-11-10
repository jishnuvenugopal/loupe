
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state = A;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s == 0) begin
                        state <= A;
                    end else if (s == 1) begin
                        state <= B;
                    end
                end
                B: begin
                    if (w == 1) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    
                    counter <= 0;
                end
                default: begin
                    state <= A;
                    z <= 0;
                end
            endcase
        end
    end

    
    reg counter = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else begin
            if (w == 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
            end
        end
    end

endmodule
