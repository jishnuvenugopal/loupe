
module TopModule (
    input  clk,
    input  a,
    output reg [2:0] q
);

    
    reg [2:0] state;

    
    reg reset;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            state <= 3'b000;
        end else begin
            
            case (state)
                3'b000: begin
                    if (a) begin
                        state <= 3'b001;
                    end else begin
                        state <= 3'b000;
                    end
                end
                3'b001: begin
                    if (a) begin
                        state <= 3'b010;
                    end else begin
                        state <= 3'b001;
                    end
                end
                3'b010: begin
                    if (a) begin
                        state <= 3'b011;
                    end else begin
                        state <= 3'b010;
                    end
                end
                3'b011: begin
                    if (a) begin
                        state <= 3'b100;
                    end else begin
                        state <= 3'b011;
                    end
                end
                3'b100: begin
                    if (a) begin
                        state <= 3'b101;
                    end else begin
                        state <= 3'b100;
                    end
                end
                3'b101: begin
                    if (a) begin
                        state <= 3'b110;
                    end else begin
                        state <= 3'b101;
                    end
                end
                3'b110: begin
                    if (a) begin
                        state <= 3'b111;
                    end else begin
                        state <= 3'b110;
                    end
                end
                3'b111: begin
                    if (a) begin
                        state <= 3'b000;
                    end else begin
                        state <= 3'b111;
                    end
                end
            endcase
        end
    end

    
    assign q = state;

endmodule
