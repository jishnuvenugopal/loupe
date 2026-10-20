
module TopModule(clk, areset, in, out);
    parameter WIDTH = 2;

    input clk;
    input areset;
    input in;
    output reg out;

    
    reg [WIDTH-1:0] current_state, next_state;

    
    localparam STATE_A = 2'b00,
                STATE_B = 2'b01,
                STATE_C = 2'b10,
                STATE_D = 2'b11;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_A;
        end
        else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (in == 1'b0) begin
                    next_state = STATE_A;
                end
                else begin
                    next_state = STATE_B;
                end
                out = 1'b0;
            end

            STATE_B: begin
                if (in == 1'b0) begin
                    next_state = STATE_C;
                end
                else begin
                    next_state = STATE_B;
                end
                out = 1'b0;
            end

            STATE_C: begin
                if (in == 1'b0) begin
                    next_state = STATE_A;
                end
                else begin
                    next_state = STATE_D;
                end
                out = 1'b0;
            end

            STATE_D: begin
                if (in == 1'b0) begin
                    next_state = STATE_C;
                end
                else begin
                    next_state = STATE_B;
                end
                out = 1'b1;
            end

            default: begin
                
                next_state = STATE_A;
                out = 1'b0;
            end
        endcase
    end

endmodule
