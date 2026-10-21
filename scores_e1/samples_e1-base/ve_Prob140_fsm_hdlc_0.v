
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {Idle, Discard, Error} state_t;

    
    state_t state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= state;
        end
    end

    
    always @(posedge clk) begin
        case (state)
            Idle: begin
                if (in == 1) begin
                    state <= Discard;
                end
            end
            Discard: begin
                if (in == 1) begin
                    state <= Discard;
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
                    err <= 1;
                end
            end
        endcase
    end

    
    always @(posedge clk) begin
        case (state)
            Idle: begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            Discard: begin
                disc <= 1;
                flag <= 0;
                err <= 0;
            end
            Error: begin
                disc <= 0;
                flag <= 0;
                err <= 1;
            end
        endcase
    end

endmodule
