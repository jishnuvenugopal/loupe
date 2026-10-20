
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    
    reg [2:0] state;

    
    wire z_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= w ? 3'b001 : 3'b000;
 
                3'b001: state <= w ? 3'b010 : 3'b001;
 
                3'b010: state <= w ? 3'b011 : 3'b010;
 
                3'b011: state <= w ? 3'b100 : 3'b011;
 
                3'b100: state <= w ? 3'b101 : 3'b100;
 
                3'b101: state <= w ? 3'b110 : 3'b101;
 
                3'b110: state <= w ? 3'b111 : 3'b110;
 
                3'b111: state <= w ? 3'b000 : 3'b111;
 
                default: state <= 3'b000;
            endcase
        end
    end

    
    always @(posedge clk) begin
        case (state)
            3'b000: z_reg <= 1'b0;
 
            3'b001: z_reg <= 1'b1;
 
            3'b010: z_reg <= 1'b1;
 
            3'b011: z_reg <= 1'b0;
 
            3'b100: z_reg <= 1'b1;
 
            3'b101: z_reg <= 1'b0;
 
            3'b110: z_reg <= 1'b0;
 
            3'b111: z_reg <= 1'b0;
 
            default: z_reg <= 1'b0;
        endcase
    end

    
    assign z = z_reg;

endmodule
