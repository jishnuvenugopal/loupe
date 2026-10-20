
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [2:0] state;

    
    always @(*) begin
        if (reset)
            state = 3'b000;
 
        else begin
            case (state)
                3'b000: state = w ? 3'b001 : 3'b000;
 
                3'b001: state = w ? 3'b010 : 3'b001;
 
                3'b010: state = w ? 3'b011 : 3'b010;
 
                3'b011: state = w ? 3'b100 : 3'b011;
 
                3'b100: state = w ? 3'b101 : 3'b011;
 
                3'b101: state = w ? 3'b101 : 3'b011;
 
                default: state = 3'b000;
 
            endcase
        end
    end

    
    always @(posedge clk) begin
        case (state)
            3'b000: z = 1'b0;
 
            3'b001: z = 1'b1;
 
            3'b010: z = 1'b0;
 
            3'b011: z = 1'b1;
 
            3'b100: z = 1'b1;
 
            3'b101: z = 1'b0;
 
            default: z = 1'b0;
 
        endcase
    end

endmodule
