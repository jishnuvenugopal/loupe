
module TopModule (
    input wire [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    case (scancode)
        16'bhe06b: left = 1'b1;
 down = 0;
 right = 0;
 up = 0;
        16'bhe072: left = 0;
 down = 1'b1;
 right = 0;
 up = 0;
        16'bhe074: left = 0;
 down = 0;
 right = 1'b1;
 up = 0;
        16'bhe075: left = 0;
 down = 0;
 right = 0;
 up = 1'b1;
        default: left = 0;
 down = 0;
 right = 0;
 up = 0;
    endcase
end

endmodule
