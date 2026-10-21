
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {Idle, Flag, Error} state_t;
    state_t state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                Idle: begin
                    if (in == 1) begin
                        state <= Flag;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= Idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                Flag: begin
                    if (in == 1) begin
                        state <= Error;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= Idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                Error: begin
                    if (in == 1) begin
                        state <= Error;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= Idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
            endcase

            
            disc <= (state == Flag);
            flag <= (state == Flag);
            err <= (state == Error);
        end
    end

endmodule
