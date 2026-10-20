
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire [2:0] r,
    output reg  [2:0] g
);

    
    reg [2:0] state;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= 3'b000;
        else
            case (state)
                3'b000: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b001: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b010: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b011: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b100: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b101: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b110: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                3'b111: state <= (r == 3'b000) ? 3'b000 : (r[0] ? 3'b001 : (r[1] ? 3'b010 : 3'b011));
                default: state <= 3'b000;
            endcase
    end

    
    always @(*) begin
        case (state)
            3'b000: begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
            3'b001: begin
                g[0] = 1'b1;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
            3'b010: begin
                g[0] = 1'b0;
                g[1] = 1'b1;
                g[2] = 1'b0;
            end
            3'b011: begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b1;
            end
            3'b100: begin
                g[0] = 1'b1;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
            3'b101: begin
                g[0] = 1'b0;
                g[1] = 1'b1;
                g[2] = 1'b0;
            end
            3'b110: begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b1;
            end
            3'b111: begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b1;
            end
            default: begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
        endcase
    end

endmodule
