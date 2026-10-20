
module TopModule (
    input wire clk,
    input wire x,
    output wire z
);

    
    typedef enum {XOR, AND, OR} state_t;
    state_t current_state, next_state;

    
    reg d1, d2, d3;

    
    assign z = d1 ^ d2 ^ d3;

    
    always @(posedge clk) begin
        
        if (!clk) begin
            d1 <= 0;
            d2 <= 0;
            d3 <= 0;
        end else begin
            
            case (current_state)
                XOR: begin
                    if (x) begin
                        next_state = AND;
                    end else begin
                        next_state = OR;
                    end
                end
                AND: begin
                    if (x) begin
                        next_state = OR;
                    end else begin
                        next_state = XOR;
                    end
                end
                OR: begin
                    if (x) begin
                        next_state = XOR;
                    end else begin
                        next_state = AND;
                    end
                end
            endcase

            
            current_state <= next_state;

            
            case (current_state)
                XOR: d1 <= x;
                AND: d2 <= ~x;
                OR: d3 <= ~x;
            endcase
        end
    end

endmodule
