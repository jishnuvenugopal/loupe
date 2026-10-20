
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (bump_left && bump_right) begin
                        state <= 2'b01;
 
                    end else if (bump_left) begin
                        state <= 2'b10;
 
                    end else if (bump_right) begin
                        state <= 2'b11;
 
                    end
                end
                2'b01: begin 
                    state <= 2'b00;
 
                end
                2'b10: begin 
                    if (bump_right) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b11: begin 
                    if (bump_left) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        if (state == 2'b00) begin 
            walk_left = 1'b1;
            walk_right = 1'b0;
        end else if (state == 2'b01) begin 
            walk_left = 1'b0;
            walk_right = 1'b0;
        end else if (state == 2'b10) begin 
            walk_left = 1'b1;
            walk_right = 1'b0;
        end else if (state == 2'b11) begin 
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    end

endmodule
