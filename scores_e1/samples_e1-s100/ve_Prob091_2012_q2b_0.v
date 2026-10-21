
module TopModule (
    input wire [5:0] y,  
    input wire w,       
    output reg Y1,      
    output reg Y3       
);


reg [1:0] state;


reg [1:0] y1_flipflop;
reg [1:0] y3_flipflop;


always @(posedge w) begin
    case (state)
        2'b00: begin
            if (y[5] == 1) begin
                state <= 2'b01;
            end else begin
                state <= 2'b00;
            end
        end
        2'b01: begin
            if (y[5] == 1) begin
                state <= 2'b10;
            end else begin
                state <= 2'b01;
            end
        end
        2'b10: begin
            if (y[5] == 1) begin
                state <= 2'b11;
            end else begin
                state <= 2'b10;
            end
        end
        2'b11: begin
            if (y[5] == 1) begin
                state <= 2'b00;
            end else begin
                state <= 2'b11;
            end
        end
    endcase
end


assign Y1 = y1_flipflop;
assign Y3 = y3_flipflop;


always @(posedge w) begin
    case (state)
        2'b00: begin
            y1_flipflop <= 1'b0;
            y3_flipflop <= 1'b0;
        end
        2'b01: begin
            y1_flipflop <= 1'b1;
            y3_flipflop <= 1'b0;
        end
        2'b10: begin
            y1_flipflop <= 1'b0;
            y3_flipflop <= 1'b1;
        end
        2'b11: begin
            y1_flipflop <= 1'b0;
            y3_flipflop <= 1'b1;
        end
    endcase
end

endmodule
