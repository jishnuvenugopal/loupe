
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

    
    localparam SPLIT_ST   = 3'd0,
               WALK_L_ST  = 3'd1,
               WALK_R_ST  = 3'd2,
               FALL_ST    = 3'd3,
               DIG_ST     = 3'd4;

    reg [2:0] state, next_state;
    reg prev_dir;
 
    reg [4:0] fall_time;
 
    reg current_dir;
 

    
    assign walk_left = (state == WALK_L_ST);
    assign walk_right = (state == WALK_R_ST);
    assign aaah = (state == FALL_ST) && (fall_time >= 21);
 
    assign digging = (state == DIG_ST);

    
    wire bump_any = bump_left | bump_right;
    wire bump_swap = bump_left & bump_right;

    
    always @(posedge clk) begin
        if (areset) begin
            state <= WALK_L_ST;
            current_dir <= 0;
            prev_dir <= 0;
            fall_time <= 0;
        end else begin
            case (state)
                WALK_L_ST: begin
                    if (!ground) begin 
                        state <= FALL_ST;
                        prev_dir <= 0;
                        fall_time <= 0;
                    end else if (dig && ground) begin 
                        state <= DIG_ST;
                    end else if (bump_any) begin 
                        current_dir <= (bump_left && !bump_right) ? 1 : 
                                      (bump_right && !bump_left) ? 0 : 
                                      ~current_dir;
 
                    end
                end
                WALK_R_ST: begin
                    if (!ground) begin
                        state <= FALL_ST;
                        prev_dir <= 1;
                        fall_time <= 0;
                    end else if (dig && ground) begin
                        state <= DIG_ST;
                    end else if (bump_any) begin
                        current_dir <= (bump_left && !bump_right) ? 1 : 
                                      (bump_right && !bump_left) ? 0 : 
                                      ~current_dir;
                    end
                end
                FALL_ST: begin
                    if (ground) begin
                        if (fall_time >= 21) begin 
                            state <= SPLIT_ST;
                        end else begin 
                            state <= prev_dir ? WALK_R_ST : WALK_L_ST;
                        end
                    end else begin
                        fall_time <= fall_time + 1;
                    end
                end
                DIG_ST: begin
                    if (!ground) begin 
                        state <= FALL_ST;
                        prev_dir <= current_dir;
                        fall_time <= 0;
                    end
                end
                SPLIT_ST: begin 
                    state <= SPLIT_ST;
                end
                default: state <= WALK_L_ST;
            endcase
        end
    end
endmodule
