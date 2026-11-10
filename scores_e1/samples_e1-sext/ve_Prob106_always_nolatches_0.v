
module TopModule (
    input wire [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    case (scancode)
        16'h06b: left = 1'b1;
 down = 1'b0;
 right = 1'b0;
 up = 1'b0;
        16'h072: left = 1'b0;
 down = 1'b1;
 right = 1'b0;
 up = 1'b0;
        16'h074: left = 1'b0;
 down = 1'b0;
 right = 1'b1;
 up = 1'b0;
        16'h075: left = 1'b0;
 down = 1'b0;
 right = 1'b0;
 up = 1'b1;
        default: left = 1'b0;
 down = 1'b0;
 right = 1'b0;
 up = 1'b0;
    endcase
end

endmodule
