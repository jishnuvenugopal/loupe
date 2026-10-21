
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    
    typedef enum {walking_left, walking_right} state_t;

    
    state_t state;

    
    reg [1:0] output_bits;

    
    initial begin
        state = walking_left;
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state = walking_left;
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end else begin
            case (state)
                walking_left: begin
                    if (bump_left) begin
                        state = walking_right;
                    end else if (bump_right) begin
                        state = walking_left;
                    end else if (ground) begin
                        state = walking_left;
                    end else begin
                        state = walking_left;
                    end
                end
                walking_right: begin
                    if (bump_right) begin
                        state = walking_left;
                    end else if (bump_left) begin
                        state = walking_right;
                    end else if (ground) begin
                        state = walking_right;
                    end else begin
                        state = walking_right;
                    end
                end
            endcase

            
            case (state)
                walking_left: output_bits = 2'b00;
                walking_right: output_bits = 2'b11;
            endcase

            
            walk_left <= output_bits[0];
            walk_right <= output_bits[1];
            aaah <= output_bits[2];
        end
    end

endmodule
