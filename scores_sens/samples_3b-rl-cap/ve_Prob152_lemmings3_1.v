
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

    
    reg [1:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (ground == 1'b0) begin
                        state <= 2'b10;
 
                    end else if (dig == 1'b1) begin
                        state <= 2'b11;
 
                    end else if (bump_right) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin 
                    if (ground == 1'b0) begin
                        state <= 2'b10;
 
                    end else if (dig == 1'b1) begin
                        state <= 2'b11;
 
                    end else if (bump_left) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                    end
                end
                2'b10: begin 
                    if (ground == 1'b1) begin
                        state <= 2'b00;
 
                    end else begin
                        state <= 2'b10;
 
                    end
                end
                2'b11: begin 
                    if (ground == 1'b0) begin
                        state <= 2'b10;
 
                    end else begin
                        state <= 2'b11;
 
                    end
                end
                default: state <= 2'b00;
 
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            2'b00: begin 
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            2'b01: begin 
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end
            2'b10: begin 
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            2'b11: begin 
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule
