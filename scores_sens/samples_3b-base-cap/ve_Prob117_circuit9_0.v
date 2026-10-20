
module TopModule(
    input  clk,
    input  a,
    output reg [2:0] q
);

    
    reg [1:0] state;

    
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (a) begin
                    state <= 2'b01;
                    q <= 3'b001;
                end else begin
                    state <= 2'b00;
                    q <= 3'b000;
                end
            end
            2'b01: begin
                if (a) begin
                    state <= 2'b10;
                    q <= 3'b010;
                end else begin
                    state <= 2'b01;
                    q <= 3'b001;
                end
            end
            2'b10: begin
                if (a) begin
                    state <= 2'b11;
                    q <= 3'b011;
                end else begin
                    state <= 2'b10;
                    q <= 3'b010;
                end
            end
            2'b11: begin
                if (a) begin
                    state <= 2'b00;
                    q <= 3'b100;
                end else begin
                    state <= 2'b11;
                    q <= 3'b011;
                end
            end
        endcase
    end

endmodule
