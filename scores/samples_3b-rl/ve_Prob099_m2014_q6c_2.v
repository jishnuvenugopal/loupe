
module TopModule (
    input        clk,
    input        reset,
    input [6:0]  y,
    input        w,
    output       Y1,
    output       Y3
);

    
    reg [5:0] state;
    reg Y2, Y4;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 6'b000001;
        end else begin
            case (state)
                6'b000001: begin
                    if (w) begin
                        state <= 6'b000010;
                    end else begin
                        state <= 6'b000001;
                    end
                end
                6'b000010: begin
                    if (w) begin
                        state <= 6'b000100;
                    end else begin
                        state <= 6'b000010;
                    end
                end
                6'b000100: begin
                    if (w) begin
                        state <= 6'b001000;
                    end else begin
                        state <= 6'b000100;
                    end
                end
                6'b001000: begin
                    if (w) begin
                        state <= 6'b010000;
                    end else begin
                        state <= 6'b001000;
                    end
                end
                6'b010000: begin
                    if (w) begin
                        state <= 6'b100000;
                    end else begin
                        state <= 6'b010000;
                    end
                end
                6'b100000: begin
                    if (w) begin
                        state <= 6'b000001;
                    end else begin
                        state <= 6'b100000;
                    end
                end
                default: begin
                    state <= 6'b000001;
                end
            endcase
        end
    end

    
    assign Y1 = y[1];
    assign Y3 = y[3];
    assign Y2 = y[1];
    assign Y4 = y[3];

endmodule
