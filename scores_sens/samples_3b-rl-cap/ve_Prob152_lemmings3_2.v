
module TopModule (
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    input        ground,
    input        dig,
    output reg   walk_left,
    output reg   walk_right,
    output reg   aaah,
    output reg   digging
);

    
    
    
    
    
    
    
    
    
    
    
    

    
    reg [2:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000;
 
        end else begin
            case (state)
                3'b000: begin 
                    if (bump_left) begin
                        state <= 3'b100;
 
                    end else if (bump_right) begin
                        state <= 3'b010;
 
                    end else if (ground) begin
                        state <= 3'b001;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b001: begin 
                    if (bump_left) begin
                        state <= 3'b100;
 
                    end else if (bump_right) begin
                        state <= 3'b010;
 
                    end else if (ground) begin
                        state <= 3'b001;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b010: begin 
                    if (bump_left) begin
                        state <= 3'b100;
 
                    end else if (bump_right) begin
                        state <= 3'b010;
 
                    end else if (ground) begin
                        state <= 3'b010;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b100: begin 
                    if (bump_left) begin
                        state <= 3'b100;
 
                    end else if (bump_right) begin
                        state <= 3'b010;
 
                    end else if (ground) begin
                        state <= 3'b001;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b101: begin 
                    if (ground) begin
                        state <= 3'b001;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b002: begin 
                    if (ground) begin
                        state <= 3'b002;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b102: begin 
                    if (ground) begin
                        state <= 3'b002;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                3'b103: begin 
                    if (ground) begin
                        state <= 3'b002;
 
                    end else begin
                        state <= 3'b101;
 
                    end
                end
                default: state <= 3'b000;
 
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            3'b000: begin 
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b0;
                digging   = 1'b0;
            end
            3'b001: begin 
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah      = 1'b0;
                digging   = 1'b0;
            end
            3'b010: begin 
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah      = 1'b0;
                digging   = 1'b0;
            end
            3'b100: begin 
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah      = 1'b0;
                digging   = 1'b0;
            end
            3'b101: begin 
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b1;
                digging   = 1'b0;
            end
            3'b002: begin 
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b0;
                digging   = 1'b1;
            end
            3'b102: begin 
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b1;
                digging   = 1'b0;
            end
            3'b103: begin 
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b1;
                digging   = 1'b0;
            end
            default: begin
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah      = 1'b0;
                digging   = 1'b0;
            end
        endcase
    end

endmodule
