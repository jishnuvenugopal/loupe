
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  [3:0] ena,
    output reg  [15:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 16'd0;
        ena <= 4'd0;
    end else begin
        case (q)
            16'd0: begin
                q <= 16'd1;
                ena <= 4'd15;
            end
            16'd1: begin
                q <= 16'd2;
                ena <= 4'd15;
            end
            16'd2: begin
                q <= 16'd3;
                ena <= 4'd15;
            end
            16'd3: begin
                q <= 16'd4;
                ena <= 4'd15;
            end
            16'd4: begin
                q <= 16'd5;
                ena <= 4'd15;
            end
            16'd5: begin
                q <= 16'd6;
                ena <= 4'd15;
            end
            16'd6: begin
                q <= 16'd7;
                ena <= 4'd15;
            end
            16'd7: begin
                q <= 16'd8;
                ena <= 4'd15;
            end
            16'd8: begin
                q <= 16'd9;
                ena <= 4'd15;
            end
            16'd9: begin
                q <= 16'd0;
                ena <= 4'd15;
            end
            default: begin
                q <= q + 16'd1;
                ena <= 4'd15;
            end
        endcase
    end
end

endmodule
