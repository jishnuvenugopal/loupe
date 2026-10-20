
module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    reg [1:0] state;
    reg [1:0] next_state;

    
    parameter STATE_A = 2'b00;
    parameter STATE_B = 2'b01;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            STATE_A: begin
                if (x == 1'b0) begin
                    next_state = STATE_A;
                end else begin
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                if (x == 1'b0) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            default: begin
                next_state = STATE_A;
 
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            STATE_A: begin
                z = 1'b1 - x;
            end
            STATE_B: begin
                z = x;
            end
            default: begin
                z = 1'bx;
 
            end
        endcase
    end

endmodule
