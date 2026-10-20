
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

wire [1:0] current_level = (s[2] ? 2'd2 : (s[1] ? 2'd1 : (s[0] ? 2'd0 : 2'd3)));
wire [1:0] prev_level = (prev_s[2] ? 2'd2 : (prev_s[1] ? 2'd1 : (prev_s[0] ? 2'd0 : 2'd3)));

always @(*) begin
    if (reset) begin
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else begin
        case (current_level)
            2'd2: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b0;
            end
            2'd1: begin
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
            end
            2'd0: begin
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
            default: begin
                fr2 = 1'b1;
                fr1 = 1'b1;
                fr0 = 1'b1;
            end
        endcase

        if (current_level != 2'd3 && prev_level != 2'd3) begin
            dfr = (prev_level < current_level) ? 1'b1 : 1'b0;
        end else begin
            dfr = 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

endmodule
