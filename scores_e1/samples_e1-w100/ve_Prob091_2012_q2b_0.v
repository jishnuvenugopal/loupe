
module TopModule (
    input wire [5:0] y,  
    input wire w,       
    output reg Y1,     
    output reg Y3      
);


reg [1:0] state;


always @(posedge w) begin
    case (state)
        2'b00: begin
            if (y[5:0] == 6'b000001) state <= 2'b01;
            else if (y[5:0] == 6'b000010) state <= 2'b10;
            else if (y[5:0] == 6'b000100) state <= 2'b11;
            else if (y[5:0] == 6'b001000) state <= 2'b00;
            else if (y[5:0] == 6'b010000) state <= 2'b01;
            else if (y[5:0] == 6'b100000) state <= 2'b10;
        end
        2'b01: begin
            if (y[5:0] == 6'b000001) state <= 2'b11;
            else if (y[5:0] == 6'b000010) state <= 2'b00;
            else if (y[5:0] == 6'b000100) state <= 2'b01;
            else if (y[5:0] == 6'b001000) state <= 2'b10;
            else if (y[5:0] == 6'b010000) state <= 2'b11;
            else if (y[5:0] == 6'b100000) state <= 2'b00;
        end
        2'b10: begin
            if (y[5:0] == 6'b000001) state <= 2'b00;
            else if (y[5:0] == 6'b000010) state <= 2'b01;
            else if (y[5:0] == 6'b000100) state <= 2'b10;
            else if (y[5:0] == 6'b001000) state <= 2'b11;
            else if (y[5:0] == 6'b010000) state <= 2'b00;
            else if (y[5:0] == 6'b100000) state <= 2'b01;
        end
        2'b11: begin
            if (y[5:0] == 6'b000001) state <= 2'b01;
            else if (y[5:0] == 6'b000010) state <= 2'b00;
            else if (y[5:0] == 6'b000100) state <= 2'b01;
            else if (y[5:0] == 6'b001000) state <= 2'b10;
            else if (y[5:0] == 6'b010000) state <= 2'b11;
            else if (y[5:0] == 6'b100000) state <= 2'b00;
        end
        default: state <= 2'b00;
    endcase
end


assign Y1 = state[1];
assign Y3 = state[3];

endmodule
