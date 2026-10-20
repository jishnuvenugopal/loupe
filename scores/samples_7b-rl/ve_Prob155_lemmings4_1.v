
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    
    parameter S_LEFT      = 3'd0;
    parameter S_RIGHT     = 3'd1;
    parameter S_FALLING   = 3'd2;
    parameter S_DIG       = 3'd3;
    parameter S_SPLAT     = 3'd4;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg prev_state;
 
    reg splattering;

    
    assign walk_left  = (state == S_LEFT) && !splattering;
    assign walk_right = (state == S_RIGHT) && !splattering;
    assign aaah       = (state == S_FALLING);
    assign digging    = (state == S_DIG);

    always @(posedge clk) begin
        if (areset) begin
            state <= S_LEFT;
            fall_counter <= 0;
            prev_state <= S_LEFT;
            splattering <= 0;
        end else begin
            if (state == S_SPLAT) begin
                
            end else begin
                case (state)
                    S_LEFT: begin
                        if (ground == 0) begin
                            
                            state <= S_FALLING;
                            prev_state <= S_LEFT;
                            fall_counter <= 0;
                        end else if (dig && ground && !splattering) begin
                            
                            state <= S_DIG;
                        end else if (bump_left || bump_right) begin
                            
                            state <= S_RIGHT;
                        end
                    end
                    S_RIGHT: begin
                        if (ground == 0) begin
                            
                            state <= S_FALLING;
                            prev_state <= S_RIGHT;
                            fall_counter <= 0;
                        end else if (dig && ground && !splattering) begin
                            
                            state <= S_DIG;
                        end else if (bump_left || bump_right) begin
                            
                            state <= S_LEFT;
                        end
                    end
                    S_FALLING: begin
                        if (ground) begin
                            
                            if (fall_counter >= 20) begin
                                state <= S_SPLAT;
                                splattering <= 1;
                            end else begin
                                
                                if (prev_state == S_LEFT) begin
                                    state <= S_LEFT;
                                end else begin
                                    state <= S_RIGHT;
                                end
                                fall_counter <= 0;
                            end
                        end else begin
                            
                            fall_counter <= fall_counter + 1;
                        end
                    end
                    S_DIG: begin
                        if (ground == 0) begin
                            
                            state <= S_FALLING;
                            prev_state <= S_DIG;
                            fall_counter <= 0;
                        end
                    end
                    S_SPLAT: begin
                        
                    end
                    default: state <= S_LEFT;
                endcase
            end
        end
    end

endmodule
