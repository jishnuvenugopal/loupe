
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [6:0]  y,
    input  wire        w,
    output reg         Y1,
    output reg         Y3
);

    
    reg [5:0] state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 6'b000001;
        end else begin
            case (state)
                6'b000001: begin
                    if (y[1] && y[3]) state <= 6'b000010;
 
                    else if (w) state <= 6'b000001;
 
                    else state <= 6'b000001;
 
                end
                6'b000010: begin
                    if (y[1] && y[3]) state <= 6'b000100;
 
                    else if (w) state <= 6'b000010;
 
                    else state <= 6'b000010;
 
                end
                6'b000100: begin
                    if (y[1] && y[3]) state <= 6'b001000;
 
                    else if (w) state <= 6'b000100;
 
                    else state <= 6'b000100;
 
                end
                6'b001000: begin
                    if (y[1] && y[3]) state <= 6'b010000;
 
                    else if (w) state <= 6'b001000;
 
                    else state <= 6'b001000;
 
                end
                6'b010000: begin
                    if (y[1] && y[3]) state <= 6'b100000;
 
                    else if (w) state <= 6'b010000;
 
                    else state <= 6'b010000;
 
                end
                6'b100000: begin
                    if (y[1] && y[3]) state <= 6'b000001;
 
                    else if (w) state <= 6'b100000;
 
                    else state <= 6'b100000;
 
                end
                default: state <= 6'b000001;
 
            endcase
        end
    end

    
    assign Y1 = state[0];
    assign Y3 = state[2];

endmodule
