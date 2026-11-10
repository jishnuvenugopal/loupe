
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {Idle, Flag, Error} state_t;

    
    state_t state = Idle;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                Idle: begin
                    if (in == 0) begin
                        state <= Flag;
                    end
                end
                Flag: begin
                    if (in == 1) begin
                        state <= Error;
                    end else if (in == 0) begin
                        state <= Idle;
                        disc <= 1;
                    end
                end
                Error: begin
                    if (in == 1) begin
                        state <= Error;
                    end else if (in == 0) begin
                        state <= Idle;
                        flag <= 1;
                    end
                end
            endcase
        end
    end

    
    assign disc = state == Flag;
    assign flag = state == Flag;
    assign err = state == Error;

endmodule
