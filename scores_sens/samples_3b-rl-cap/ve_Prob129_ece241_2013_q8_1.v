
module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    
    typedef enum {IDLE, X, ONE} state_t;
    state_t state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z     <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (x == 1'b1) begin
                        state <= X;
                    end else begin
                        state <= IDLE;
                    end
                end
                X: begin
                    if (x == 1'b0) begin
                        state <= ONE;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONE: begin
                    if (x == 1'b1) begin
                        state <= IDLE;
                        z     <= 1'b1;
                    end else begin
                        state <= IDLE;
                        z     <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
