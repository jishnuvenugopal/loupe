
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    typedef enum {IDLE, INCREMENT, DECREMENT} state_t;
    state_t state_reg;

    
    reg [1:0] counter_reg;

    
    always @(posedge areset or posedge clk) begin
        if (arst) begin
            state_reg <= IDLE;
            counter_reg <= 2'b00;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (train_valid && train_taken) begin
                        state_reg <= INCREMENT;
                        counter_reg <= counter_reg + 1'b1;
                    end else if (train_valid && ~train_taken) begin
                        state_reg <= DECREMENT;
                        counter_reg <= counter_reg - 1'b1;
                    end else begin
                        state_reg <= IDLE;
                    end
                end
                INCREMENT: begin
                    if (counter_reg == 2'b11) begin
                        state_reg <= IDLE;
                        counter_reg <= 2'b00;
                    end else begin
                        state_reg <= INCREMENT;
                        counter_reg <= counter_reg + 1'b1;
                    end
                end
                DECREMENT: begin
                    if (counter_reg == 2'b00) begin
                        state_reg <= IDLE;
                        counter_reg <= 2'b11;
                    end else begin
                        state_reg <= DECREMENT;
                        counter_reg <= counter_reg - 1'b1;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (arst) begin
            state <= 2'b00;
        end else begin
            state <= counter_reg;
        end
    end

endmodule
