
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    
    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state   <= 2'b00;
 
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah     <= 1'b1;
        end else begin
            case (state)
                2'b00: begin 
                    if (ground) begin
                        
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                        aaah     <= 1'b0;
                    end else begin
                        
                        state   <= 2'b10;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah     <= 1'b1;
                    end
                end
                2'b01: begin 
                    if (ground) begin
                        
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                        aaah     <= 1'b0;
                    end else begin
                        
                        state   <= 2'b10;
                        walk_left <= 1'b0;
                        walk_right <= 1'b0;
                        aaah     <= 1'b1;
                    end
                end
                2'b10: begin 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah     <= 1'b1;
                end
                2'b11: begin 
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah     <= 1'b1;
                end
                default: begin
                    state   <= 2'b00;
 
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah     <= 1'b1;
                end
            endcase
            if (ground) begin
                if (bump_left && bump_right) begin
                    state   <= 2'b11;
 
                end else if (bump_left) begin
                    state   <= 2'b01;
 
                end else if (bump_right) begin
                    state   <= 2'b00;
 
                end
            end
        end
    end

endmodule
