
module TopModule (
    input        clk,
    input        x,
    input [2:0]  y,
    output       Y0,
    output       z
);

    
    reg [2:0] state;

    
    always @(posedge clk) begin
        case (state)
            3'b000: begin
                if (x == 1'b0)
                    state <= 3'b001;
                else
                    state <= 3'b000;
            end
            3'b001: begin
                if (x == 1'b0)
                    state <= 3'b001;
                else
                    state <= 3'b100;
            end
            3'b010: begin
                if (x == 1'b0)
                    state <= 3'b010;
                else
                    state <= 3'b001;
            end
            3'b011: begin
                if (x == 1'b0)
                    state <= 3'b001;
                else
                    state <= 3'b010;
            end
            3'b100: begin
                if (x == 1'b0)
                    state <= 3'b011;
                else
                    state <= 3'b100;
            end
            3'b101: begin
                if (x == 1'b0)
                    state <= 3'b011;
                else
                    state <= 3'b101;
            end
            3'b110: begin
                if (x == 1'b0)
                    state <= 3'b110;
                else
                    state <= 3'b101;
            end
            3'b111: begin
                if (x == 1'b0)
                    state <= 3'b111;
                else
                    state <= 3'b110;
            end
            default: state <= 3'b000;
        endcase
    end

    
    assign Y0 = state[0];
    assign z   = (state == 3'b110) || (state == 3'b111);

endmodule
