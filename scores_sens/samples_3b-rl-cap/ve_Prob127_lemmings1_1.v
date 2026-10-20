
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    
    reg [0:0] state;

    
    reg [0:0] output_reg;

    
    
    

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            output_reg <= 2'b01;
 
        end else begin
            case (state)
                2'b00: begin 
                    if (bump_left && bump_right) begin
                        state <= 2'b00;
 
                        output_reg <= 2'b01;
 
                    end else if (bump_left) begin
                        state <= 2'b01;
 
                        output_reg <= 2'b00;
 
                    end else if (bump_right) begin
                        state <= 2'b00;
 
                        output_reg <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                        output_reg <= 2'b01;
 
                    end
                end
                2'b01: begin 
                    if (bump_left && bump_right) begin
                        state <= 2'b00;
 
                        output_reg <= 2'b01;
 
                    end else if (bump_left) begin
                        state <= 2'b00;
 
                        output_reg <= 2'b01;
 
                    end else if (bump_right) begin
                        state <= 2'b01;
 
                        output_reg <= 2'b00;
 
                    end else begin
                        state <= 2'b01;
 
                        output_reg <= 2'b00;
 
                    end
                end
                default: begin
                    state <= 2'b00;
                    output_reg <= 2'b01;
 
                end
            endcase
        end
    end

    
    always @(*) begin
        case (output_reg)
            2'b01: begin 
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
            2'b00: begin 
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule
