
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    
    reg current_state, next_state;

    
    assign out = current_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_B;
  
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (in == 1'b0) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            STATE_B: begin
                if (in == 1'b0) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            default: begin
                next_state = STATE_B;
  
            end
        endcase
    end

endmodule
