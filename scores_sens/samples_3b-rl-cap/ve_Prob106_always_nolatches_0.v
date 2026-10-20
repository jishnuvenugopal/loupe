
module TopModule (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    
    reg [15:0] scancode_reg [1:0];

    
    reg [1:0] scancode_counter = 2'b00;

    
    always @(*) begin
        case (scancode)
            16'hE06B: left = 1'b1;
 
            16'hE072: down = 1'b1;
 
            16'hE074: right = 1'b1;
 
            16'hE075: up = 1'b1;
 
            default: begin
                left = 1'b0;
                down = 1'b0;
                right = 1'b0;
                up = 1'b0;
            end
        endcase
    end

    
    always @(posedge scancode_reg[0] or posedge scancode_reg[1]) begin
        if (scancode_counter == 2'b00) begin
            scancode_reg[0] <= scancode;
        end else begin
            scancode_reg[1] <= scancode;
        end
        scancode_counter <= scancode_counter + 2'b01;
    end

endmodule
