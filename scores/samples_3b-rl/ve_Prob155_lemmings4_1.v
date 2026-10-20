
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah,
    output reg  digging
);

    
    reg [2:0] state;
    
    reg [4:0] fall_counter;

    
    initial begin
        state = 3'b000;
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
        fall_counter = 5'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
            fall_counter <= 5'b0;
        end else begin
            case (state)
                3'b000: begin 
                    if (bump_left)
                        state <= 3'b001;
 
                    else if (bump_right)
                        state <= 3'b010;
 
                    else if (ground)
                        state <= 3'b011;
 
                    else
                        state <= 3'b100;
 
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                    fall_counter <= 5'b0;
                end
                3'b001: begin 
                    if (bump_right)
                        state <= 3'b000;
 
                    else if (ground)
                        state <= 3'b011;
 
                    else
                        state <= 3'b100;
 
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                    fall_counter <= 5'b0;
                end
                3'b010: begin 
                    if (bump_left)
                        state <= 3'b000;
 
                    else if (ground)
                        state <= 3'b011;
 
                    else
                        state <= 3'b100;
 
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                    fall_counter <= 5'b0;
                end
                3'b011: begin 
                    if (ground && !falling)
                        state <= 3'b011;
 
                    else
                        state <= 3'b100;
 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                    fall_counter <= 5'b0;
                end
                3'b100: begin 
                    if (ground)
                        state <= 3'b000;
 
                    else
                        state <= 3'b100;
 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                    fall_counter <= fall_counter + 1'b1;
                    if (fall_counter == 5'd20) begin
                        state <= 3'b000;
 
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah <= 1'b0;
                        digging <= 1'b0;
                        fall_counter <= 5'b0;
                    end
                end
                default: begin
                    state <= 3'b000;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                    fall_counter <= 5'b0;
                end
            endcase
        end
    end

endmodule
