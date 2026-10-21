
module TopModule (
    input wire [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            left <= 0;
            down <= 0;
            right <= 0;
            up <= 0;
        end else begin
            case (scancode)
                16'b16'he06b: left <= 1;
                16'b16'he072: down <= 1;
                16'b16'he074: right <= 1;
                16'b16'he075: up <= 1;
                default: begin
                    left <= 0;
                    down <= 0;
                    right <= 0;
                    up <= 0;
                end
            endcase
        end
    end

endmodule
