
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    reg [2:0] state;

    
    always @(*) begin
        case (state)
            3'b000: begin
                if (w == 1'b0) state = 3'b001;
 
                else          state = 3'b000;
 
            end
            3'b001: begin
                if (w == 1'b0) state = 3'b010;
 
                else          state = 3'b001;
 
            end
            3'b010: begin
                if (w == 1'b0) state = 3'b011;
 
                else          state = 3'b001;
 
            end
            3'b011: begin
                if (w == 1'b0) state = 3'b100;
 
                else          state = 3'b001;
 
            end
            3'b100: begin
                if (w == 1'b0) state = 3'b101;
 
                else          state = 3'b001;
 
            end
            3'b101: begin
                if (w == 1'b0) state = 3'b010;
 
                else          state = 3'b001;
 
            end
            default: state = 3'b000;
 
        endcase
    end

    
    always @(*) begin
        case (state)
            3'b100: z = 1'b1;
 
            default: z = 1'b0;
 
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z     <= 1'b0;
        end else begin
            state <= state;
            z     <= z;
        end
    end

endmodule
