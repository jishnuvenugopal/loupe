
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
                idle:
                    if (in == 1) begin
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
                    if (in == 1) begin
                        state <= flag;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= error;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                error:
                    if (in == 1) begin
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

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                idle:
                    if (in == 1) begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                flag:
                    if (in == 1) begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                error:
                    if (in == 1) begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
            endcase
        end
    end

endmodule
