
module TopModule (
    input        clk,
    input        reset,
    input [6:0]  y,
    input        w,
    output       Y1,
    output       Y3
);

    
    reg [5:0] state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 6'b000001;
 
        end else begin
            case (state)
                6'b000001: begin 
                    if (w == 1'b0) state <= 6'b000010;
 
                    else          state <= 6'b000001;
 
                end
                6'b000010: begin 
                    if (w == 1'b0) state <= 6'b000100;
 
                    else          state <= 6'b000010;
 
                end
                6'b000100: begin 
                    if (w == 1'b0) state <= 6'b001000;
 
                    else          state <= 6'b000100;
 
                end
                6'b001000: begin 
                    if (w == 1'b0) state <= 6'b010000;
 
                    else          state <= 6'b001000;
 
                end
                6'b010000: begin 
                    if (w == 1'b0) state <= 6'b010000;
 
                    else          state <= 6'b001000;
 
                end
                6'b100000: begin 
                    if (w == 1'b0) state <= 6'b100000;
 
                    else          state <= 6'b001000;
 
                end
                default: state <= 6'b000001;
 
            endcase
        end
    end

    
    assign Y1 = state[1];
    assign Y3 = state[3];

endmodule
