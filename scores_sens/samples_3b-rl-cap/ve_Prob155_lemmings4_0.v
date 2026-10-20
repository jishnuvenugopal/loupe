
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
    
    reg [3:0] fall_count;
    
    reg       falling;

    
    
    
    
    
    

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state   <= 3'b000;
            fall_count <= 4'b0000;
            falling <= 1'b0;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            case (state)
                3'b000: begin 
                    if (dig) begin
                        state <= 3'b004;
 
                    end else begin
                        state <= 3'b001;
 
                    end
                end
                3'b001: begin 
                    if (bump_right) begin
                        state <= 3'b002;
 
                    end else if (~ground) begin
                        state <= 3'b003;
 
                    end else if (dig) begin
                        state <= 3'b004;
 
                    end
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                3'b002: begin 
                    if (bump_left) begin
                        state <= 3'b001;
 
                    end else if (~ground) begin
                        state <= 3'b003;
 
                    end else if (dig) begin
                        state <= 3'b004;
 
                    end
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                3'b003: begin 
                    if (ground) begin
                        state <= 3'b001;
 
                    end else if (fall_count == 4'd20) begin
                        state <= 3'b005;
 
                    end
                    fall_count <= fall_count + 1'b1;
                    falling <= 1'b1;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
                3'b004: begin 
                    if (~ground) begin
                        state <= 3'b001;
 
                    end
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
                default: begin
                    state <= 3'b000;
                    fall_count <= 4'b0000;
                    falling <= 1'b0;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            3'b001: begin 
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            3'b002: begin 
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            3'b003: begin 
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            3'b004: begin 
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            default: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end

endmodule
