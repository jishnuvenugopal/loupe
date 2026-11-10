
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {idle, flag, error} state_t;

    
    state_t state = idle;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                idle: begin
                    if (in == 0) begin
                        state <= flag;
                    end
                end
                flag: begin
                    if (in == 1) begin
                        state <= error;
                    end
                end
                error: begin
                    if (in == 0) begin
                        state <= idle;
                    end
                end
            endcase
            disc <= (state == flag);
            flag <= (state == error);
            err <= (state == error);
        end
    end

endmodule
