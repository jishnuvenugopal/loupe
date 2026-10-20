
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    
    localparam IDLE_LEFT = 0;
    localparam IDLE_RIGHT = 1;
    localparam FALLING = 2;
    localparam DIG = 3;
    localparam SPLITTER = 4;

    reg [2:0] current_state;
    reg [7:0] fall_count;
    reg prev_dir;
 
    reg save_dir;
 

    
    always @(posedge clk) begin
        if (areset) begin
            current_state <= IDLE_LEFT;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
            fall_count <= 0;
            prev_dir <= 0;
            save_dir <= 0;
        end else begin
            case (current_state)
                IDLE_LEFT: begin
                    
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                    
                    if (!ground) begin
                        
                        current_state <= FALLING;
                        fall_count <= 0;
                        prev_dir <= 0;
                    end else if (dig && ground) begin
                        
                        current_state <= DIG;
                        save_dir <= 0;
                    end else if (bump_left || bump_right) begin
                        current_state <= IDLE_RIGHT;
                    end
                end

                IDLE_RIGHT: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                    
                    if (!ground) begin
                        current_state <= FALLING;
                        fall_count <= 0;
                        prev_dir <= 1;
                    end else if (dig && ground) begin
                        current_state <= DIG;
                        save_dir <= 1;
                    end else if (bump_left || bump_right) begin
                        current_state <= IDLE_LEFT;
                    end
                end

                FALLING: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    digging <= 0;
                    aaah <= 1;
                    
                    if (ground) begin 
                        current_state <= (fall_count > 20) ? SPLITTER : 
                                        (prev_dir ? IDLE_RIGHT : IDLE_LEFT);
                        fall_count <= 0;
                    end else begin
                        fall_count <= fall_count + 1;
                    end
                end

                DIG: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                    
                    if (!ground) begin
                        
                        current_state <= FALLING;
                        fall_count <= 0;
                        prev_dir <= save_dir;
                    end else begin
                        current_state <= DIG;
                    end
                end

                SPLITTER: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                    current_state <= SPLITTER;
                end

                default: current_state <= IDLE_LEFT;
            endcase
        end
    end
endmodule
