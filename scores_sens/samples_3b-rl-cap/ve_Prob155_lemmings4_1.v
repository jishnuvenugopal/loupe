
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
    reg       falling;
    reg       fall_count;
    reg       digging;
    reg       splatter;

    
    

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state   <= 3'b000;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            case (state)
                3'b000: begin 
                    if (bump_left)
                        state <= 3'b001;
 
                    else if (bump_right)
                        state <= 3'b002;
 
                    else
                        state <= 3'b000;
 
                end
                3'b001: begin 
                    if (bump_right)
                        state <= 3'b002;
 
                    else if (bump_left)
                        state <= 3'b001;
 
                    else if (bump_both)
                        state <= 3'b002;
 
                    else if (!ground)
                        state <= 3'b003;
 
                    else if (dig)
                        state <= 3'b004;
 
                    else
                        state <= 3'b001;
 
                end
                3'b002: begin 
                    if (bump_left)
                        state <= 3'b001;
 
                    else if (bump_right)
                        state <= 3'b002;
 
                    else if (bump_both)
                        state <= 3'b001;
 
                    else if (!ground)
                        state <= 3'b003;
 
                    else if (dig)
                        state <= 3'b004;
 
                    else
                        state <= 3'b002;
 
                end
                3'b003: begin 
                    if (ground)
                        state <= 3'b001;
 
                    else if (fall_count == 20)
                        state <= 3'b007;
 
                    else
                        state <= 3'b003;
 
                end
                3'b004: begin 
                    if (ground)
                        state <= 3'b004;
 
                    else
                        state <= 3'b003;
 
                end
                3'b005: begin 
                    if (ground)
                        state <= 3'b001;
 
                    else
                        state <= 3'b007;
 
                end
                3'b006: begin 
                    if (ground)
                        state <= 3'b002;
 
                    else
                        state <= 3'b007;
 
                end
                3'b007: begin 
                    state <= 3'b007;
 
                end
                default: state <= 3'b000;
 
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            case (state)
                3'b000: begin 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
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
                3'b005: begin 
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                3'b006: begin 
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
                3'b007: begin 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
                default: begin
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling <= 1'b0;
            fall_count <= 1'b0;
        end else begin
            if (state == 3'b003) begin 
                falling <= 1'b1;
                if (fall_count == 20)
                    fall_count <= 1'b0;
                else
                    fall_count <= fall_count + 1'b1;
            end else begin
                falling <= 1'b0;
                fall_count <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            digging <= 1'b0;
        end else begin
            if (state == 3'b004) begin 
                digging <= 1'b1;
            end else begin
                digging <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            splatter <= 1'b0;
        end else begin
            if (state == 3'b003 && fall_count == 20) begin 
                splatter <= 1'b1;
            end else begin
                splatter <= 1'b0;
            end
        end
    end

endmodule
