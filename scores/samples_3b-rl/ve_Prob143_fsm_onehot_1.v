
module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        
        if (state == 10'd0) begin
            next_state = 10'd0;
        end else if (state == 10'd1) begin
            next_state = 10'd1;
        end else if (state == 10'd2) begin
            next_state = 10'd0;
        end else if (state == 10'd3) begin
            next_state = 10'd0;
        end else if (state == 10'd4) begin
            next_state = 10'd0;
        end else if (state == 10'd5) begin
            next_state = 10'd8;
        end else if (state == 10'd6) begin
            next_state = 10'd9;
        end else if (state == 10'd7) begin
            next_state = 10'd0;
        end else if (state == 10'd8) begin
            next_state = 10'd1;
        end else if (state == 10'd9) begin
            next_state = 10'd1;
        end else begin
            next_state = 10'd0;
        end
    end

    always @(*) begin
        
        if (state == 10'd5) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end else if (state == 10'd6) begin
            out1 = 1'b1;
            out2 = 1'b1;
        end else if (state == 10'd7) begin
            out1 = 1'b0;
            out2 = 1'b1;
        end else if (state == 10'd8) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end else if (state == 10'd9) begin
            out1 = 1'b1;
            out2 = 1'b0;
        end else begin
            out1 = 1'b0;
            out2 = 1'b0;
        end
    end

endmodule
