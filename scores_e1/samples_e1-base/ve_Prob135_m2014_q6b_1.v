
module TopModule (
    input  wire y [2:0],
    input  wire w,
    output wire Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state = A;
    wire [2:0] next_state;

    
    reg [2:0] state_reg;
    reg [2:0] next_state_reg;

    
    wire Y1_reg;

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            state_reg <= A;
            next_state_reg <= A;
            Y1_reg <= 0;
        end else begin
            state_reg <= next_state_reg;
            next_state_reg <= next_state;
            Y1_reg <= y[1];
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            next_state <= A;
        end else begin
            case (state)
                A: begin
                    if (w == 0) begin
                        next_state <= B;
                    end else begin
                        next_state <= A;
                    end
                end
                B: begin
                    if (w == 0) begin
                        next_state <= C;
                    end else begin
                        next_state <= D;
                    end
                end
                C: begin
                    if (w == 0) begin
                        next_state <= E;
                    end else begin
                        next_state <= D;
                    end
                end
                D: begin
                    if (w == 0) begin
                        next_state <= F;
                    end else begin
                        next_state <= A;
                    end
                end
                E: begin
                    if (w == 0) begin
                        next_state <= E;
                    end else begin
                        next_state <= D;
                    end
                end
                F: begin
                    if (w == 0) begin
                        next_state <= C;
                    end else begin
                        next_state <= D;
                    end
                end
            endcase
        end
    end

    
    assign state = state_reg;
    assign next_state = next_state_reg;
    assign Y1 = Y1_reg;

endmodule
