
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {idle, flag, error} state_t;

    
    state_t state;

    
    reg prev_in;

    
    always @(posedge clk) begin
        
        prev_in <= in;

        
        if (reset) begin
            state <= idle;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            
            case (state)
                idle:
                    if (prev_in == 1) begin
                        state <= flag;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                flag:
                    if (prev_in == 1) begin
                        state <= error;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                error:
                    if (prev_in == 1) begin
                        state <= error;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
            endcase
        end
    end

    
    assign disc = state == flag;
    assign flag = state == flag;
    assign err = state == error;

endmodule
