
module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    initial begin
        state_reg = 2'b00;
 
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            state_reg <= 2'b00;
        end else begin
            current_state <= next_state;
            state_reg <= state_reg;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (s == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (w == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            default: begin
                next_state = A;
 
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            case (current_state)
                B: begin
                    if (w == 1) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                end
                default: begin
                    z <= 1'b0;
 
                end
            endcase
        end
    end

endmodule
