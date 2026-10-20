
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [2:0] state;

    
    reg state_output;

    
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

    
    always @(*) begin
        case (state)
            3'b011: state_output = 1'b1;
 
            default: state_output = 1'b0;
        endcase
    end

    
    assign z = state_output;

endmodule
