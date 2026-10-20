
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire [2:0] r,
    output reg  [2:0] g
);

    
    reg [2:0] state;

    
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: begin
                    if (r[0] || r[1] || r[2])
                        state <= 3'b001;
                    else
                        state <= 3'b000;
                end
                3'b001: begin
                    if (r[0])
                        state <= 3'b001;
                    else
                        state <= 3'b000;
                end
                3'b002: begin
                    if (r[1])
                        state <= 3'b002;
                    else
                        state <= 3'b000;
                end
                default: state <= 3'b000;
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 3'b000;
        end else begin
            case (state)
                3'b000: begin
                    if (r[0])
                        g <= 3'b001;
                    else if (r[1])
                        g <= 3'b010;
                    else if (r[2])
                        g <= 3'b100;
                    else
                        g <= 3'b000;
                end
                3'b001: begin
                    if (r[0])
                        g <= 3'b001;
                    else
                        g <= 3'b000;
                end
                3'b002: begin
                    if (r[1])
                        g <= 3'b010;
                    else
                        g <= 3'b000;
                end
                default: g <= 3'b000;
            endcase
        end
    end

endmodule
