
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

    
    reg [4:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                Idle: begin
                    if (in == 1) begin
                        count <= 0;
                        state <= Flag;
                    end
                end
                Flag: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 0;
                        state <= Idle;
                        disc <= 1;
                        flag <= 0;
                        err <= 0;
                    end
                end
                Error: begin
                    if (in == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 0;
                        state <= Idle;
                        disc <= 0;
                        flag <= 0;
                        err <= 1;
                    end
                end
            endcase
        end
    end

endmodule
