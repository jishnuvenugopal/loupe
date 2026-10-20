
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    
    reg [1:0] state;
    reg prev_state;

    localparam WALK_LEFT  = 2'b00,
               WALK_RIGHT = 2'b01,
               FALLING    = 2'b10;

    
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);

    always @(posedge clk or posedge areset)
    begin
        if (areset)
        begin
            state <= WALK_LEFT;
            prev_state <= WALK_LEFT;
        end
        else
        begin
            case (state)
                WALK_LEFT:
                begin
                    if (ground)
                    begin
                        
                        if (bump_left || bump_right)
                        begin
                            state <= WALK_RIGHT;
                        end
                        else
                        begin
                            state <= WALK_LEFT;
                        end
                    end
                    else
                    begin
                        
                        prev_state <= WALK_LEFT;
                        state <= FALLING;
                    end
                end

                WALK_RIGHT:
                begin
                    if (ground)
                    begin
                        
                        if (bump_left || bump_right)
                        begin
                            state <= WALK_LEFT;
                        end
                        else
                        begin
                            state <= WALK_RIGHT;
                        end
                    end
                    else
                    begin
                        prev_state <= WALK_RIGHT;
                        state <= FALLING;
                    end
                end

                FALLING:
                begin
                    if (ground)
                    begin
                        
                        case (prev_state)
                            WALK_LEFT : state <= WALK_LEFT;
                            WALK_RIGHT : state <= WALK_RIGHT;
                            default : state <= WALK_LEFT;
                        endcase
                    end
                    else
                    begin
                        
                        state <= FALLING;
                    end
                end

                default:
                    state <= WALK_LEFT;
            endcase
        end
    end

endmodule
