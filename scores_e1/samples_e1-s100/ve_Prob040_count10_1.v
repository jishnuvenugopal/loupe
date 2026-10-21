
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] count;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b01;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b00;
                end
            end
            2'b01: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b10;
                end
            end
            2'b11: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b11;
                end
            end
            3'b00: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b00;
                end
            end
            3'b01: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b01;
                end
            end
            3'b10: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b10;
                end
            end
            3'b11: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b11;
                end
            end
            4'b00: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b00;
                end
            end
            4'b01: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b01;
                end
            end
            4'b10: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b10;
                end
            end
            4'b11: begin
                if (count == 4'b0009) begin
                    count <= 4'b0000;
                    state <= 2'b00;
                end else begin
                    count <= count + 1'b1;
                    state <= 2'b11;
                end
            end
        endcase
    end
end

assign q[0] = count[0];
assign q[1] = count[1];
assign q[2] = count[2];
assign q[3] = count[3];
endmodule
