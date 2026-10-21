
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);


reg [2:0] count;
reg [1:0] state;


initial begin
    count = 0;
    state = 0;
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        count = 0;
        state = 0;
    end else begin
        case (state)
            3'b000: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b010;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b010: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b011;
                end else begin
                    state <= 3'b010;
                end
            end
            3'b011: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b100;
                end else begin
                    state <= 3'b011;
                end
            end
            3'b100: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b101;
                end else begin
                    state <= 3'b100;
                end
            end
            3'b101: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b110;
                end else begin
                    state <= 3'b101;
                end
            end
            3'b110: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b111;
                end else begin
                    state <= 3'b110;
                end
            end
            3'b111: begin
                if (slowena) begin
                    count <= count + 1;
                    state <= 3'b000;
                end else begin
                    state <= 3'b111;
                end
            end
            default: begin
                count <= 0;
                state <= 0;
            end
        endcase
    end
end


always @(*) begin
    q = count;
end

endmodule
